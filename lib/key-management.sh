# This shell library defines a little DSL for managing secrets on
# NixOS machines, without exposing them in the world-readable Nix
# store.
#
# The general idea: each machine has a keys.sh. It's stored in git,
# but encrypted at rest with git-crypt. The cleartext file gets synced
# to /etc/nixos along with the rest of the NixOS configs by redo. Redo
# then runs /etc/nixos/keys.sh on the target machine, which writes the
# secrets to /etc/keys, one file per key. The NixOS configuration can
# then simply refer to files under /etc/keys as needed, typically in
# passwordFile directives.
#
# keys.sh also writes out /etc/keys.nix, which is a Nix map containing
# a hash for each secret name. This file can be referenced in the main
# NixOS configs as a way of triggering rebuilds or service restarts in
# the deterministic part of the OS when secrets change.
#
# The hashes themselves can appear in the public Nix store, so in
# addition to the secret content a per-machine salt is mixed in. This
# preserves the property of the hash we care about (they change when
# the secret changes) without being of much use to hash attackers.
#
# There is no rollback support for this key management mechanism, so
# buyer beware. You probably want to roll new keys in a
# make-before-break pattern, creating a new secret and updating the
# NixOS config to depend on the new file. That way you have a window
# during which rollback is possible including secrets data.
#
# A typical keys.sh file looks like:
#
#   source /etc/nixos/lib/key-management.sh
#
#   file my-secret root root 0600 "my super secret value here"
#
#   file my-other-secret pppd pppd 0640 <<EOF
#   This secret is a bit long, so it's
#   defined in a heredoc.
#   EOF
#
#   commit

set -euo pipefail

_TMP="$(mktemp -d "${1}.XXXXXX")"
_DST="$1"

trap "rm -rf $_TMP" EXIT

file() {
    path=$_TMP/$1
    owner=$2
    group=$3
    mode=$4
    content=${5:-}

    if [ -z "$content" ]; then
        cat >$path
    else
        echo -n "$content" >$path
    fi
    chown $owner:$group $path
    chmod $mode $path
}

commit() {
    src=$_TMP
    dst=$_DST
    salt=${dst}.salt
    hashes=${dst}.nix

    chmod 0755 $src
    mkdir -p -m000 $dst
    rsync -rcpog --delete $src/ $dst

    if [ ! -f $salt ]; then
        head -c128 /dev/urandom | od -A n -v -t x1 >$salt
    fi

    tmp=${hashes}.tmp
    echo "{" >$tmp
    find $dst -type f | while read fname; do
        base=${fname%%/*}
        sha=$((cat $salt; cat $fname) | sha256sum - | cut -f1 -d' ')
        echo "  \"$(basename $fname)\" = \"$sha\";" >>$tmp
    done
    echo "}" >>$tmp
    chmod 0600 $tmp
    mv -f $tmp $hashes
}
