# A typical keys.sh file looks like:
#
#   . ../lib/key-management.sh
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

_TMP="$(mktemp -d "key.XXXXXX")"
_DST="/etc/keys"

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

    chmod 0755 $src
    mkdir -p -m000 $dst
    rsync -rcpog --delete $src/ $dst
}
