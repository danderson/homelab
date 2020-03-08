set -euo pipefail

_TMP="$(mktemp -d "${1}.XXXXXX")"
_DST="$1"

set -- "$_DST" "" "$_TMP"
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
