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

build_do() {
    if [ ! -f $dir/region -o ! -f $dir/size ]; then
        echo "missing $dir/region or $dir/size files."
        exit 1
    fi

    vm=$dir
    region=$(cat $dir/region)
    size=$(cat $dir/size)

    # Grab all SSH keys in the DigitalOcean account.
    sshkeys=$(doctl compute ssh-key list --no-header --format=ID | tr '\n' ',')

    echo "Creating droplet"
    doctl compute droplet create $vm --enable-ipv6 --size $size --image debian-10-x64 --region $region --ssh-keys $sshkeys --wait
    id=$(doctl compute droplet list $vm --no-header --format=ID)
    ip=$(doctl compute droplet list $vm --no-header --format=PublicIPv4)

    echo "Infecting droplet"
    # Ugh, wait for droplet to come up.
    sleep 30
    ssh -o StrictHostKeyChecking=accept-new root@$ip bash <<EOF
set -euo pipefail
apt update
apt install xz-utils
wget https://raw.githubusercontent.com/elitak/nixos-infect/master/nixos-infect
NO_REBOOT=true PROVIDER=digitalocean NIX_CHANNEL=nixos-19.09 bash nixos-infect
EOF

    echo "Rebooting droplet"
    # Reboot will sever the ssh connection and make it exit uncleanly.
    ssh root@$ip reboot || true
    ssh-keygen -R $ip

    # A way to - hopefully - wait until the machine's rebooted.
    sleep 30
    ssh -o StrictHostKeyChecking=accept-new root@$ip bash <<EOF
set -euo pipefail
rm -rf /old-root
EOF

    echo "creating config"
    mkdir $dir
    echo "$ip" >$dir/host
    rsync -r root@$ip:/etc/nixos/ $dir
    rm -f $dir/region $dir/size
}

exec 1>&2
redo-always $1

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

    */create)
        build_do
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
