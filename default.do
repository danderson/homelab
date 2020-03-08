# -*- mode: shell-script -*-

dir=${1%/*}

redo_subdirs() {
    cmd=$1
    find . -name configuration.nix | while read fname; do
        echo ${fname%/*}/$cmd
    done | xargs redo-ifchange
}

rebuild() {
    host=$1
    cmd=$2
    shift 2
    ssh root@$host nixos-rebuild $cmd --no-build-nix $@ >&2
}

case $1 in
    */push)
        # Create /etc/nixos and set its permissions ahead of rsync, so
        # that files are never exposed with surprising permissions.
        ssh root@$dir "mkdir -p /etc/nixos && chown root:root /etc/nixos && chmod 700 /etc/nixos"
        rsync -rL --perms --chmod=Fu=rw,Du=rwx,go-rwx --delete --delete-during --delete-excluded $dir/ root@${dir}:/etc/nixos >&2
        ;;

    */keys)
        redo-ifchange $dir/push
        ssh root@$dir "sh /etc/nixos/keys.sh /etc/keys" >&2
        ;;

    */dry)
        redo-ifchange $dir/push $dir/keys
        rebuild $dir dry-activate
        ;;

    */update)
        ssh root@$dir nix-channel --update >&2
        ;;

    */deploy)
        redo-ifchange $dir/push $dir/keys
        rebuild $dir switch
        ;;

    */rollback)
        rebuild $dir switch --rollback
        ;;

    push|keys|dry|update|deploy|rollback)
        redo_subdirs $1
        ;;

    *)
        cat >&2 <<EOF
No rule to build "$1". Some useful rules:
   */push: push nix configs
   */dry: push and dry-activate configuration
   */deploy: push and activate configuration
EOF
        exit 1
        ;;
esac
redo-always $1
