function nixos-diff() {
    old=$1
    new=$2
    nix-diff --color=always $(nix-store -qd $old $new)
}
