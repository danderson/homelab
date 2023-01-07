# Until https://github.com/NixOS/nixpkgs/pull/195521 is merged.
{ config, pkgs, lib, ... }: let
  fontsPkg = pkgs: (pkgs.runCommand "share-fonts" { preferLocalBuild = true; } ''
    mkdir -p "$out/share/fonts"
    font_regexp='.*\.\(ttf\|ttc\|otf\|pcf\|pfa\|pfb\|bdf\)\(\.gz\)?'
    find ${toString (config.fonts.fonts)} -regex "$font_regexp" \
      -exec ln -sf -t "$out/share/fonts" '{}' \;
  '');
in lib.mkIf config.my.gaming {
  programs.steam.enable = true;
  nixpkgs.config.packageOverrides = pkgs: {
    steam = pkgs.steam.override {
      extraPkgs = pkgs: with pkgs; [
        (fontsPkg pkgs)
      ];
    };
  };
}
