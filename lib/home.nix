{ config, pkgs, ... }:
let
  console-programs = with pkgs; [
    file
    fping
    git
    git-crypt
    go
    ipcalc
    lftp
    mosh
    nmap
    pwgen
  ];
  gui-programs = with pkgs; [
    gnome3.dconf-editor
    feh
    gimp
    graphviz
    pdftk
  ];
  has-gui = config.services.xserver.enable;
in
{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.dave = {
      home.packages = console-programs ++ (if has-gui then gui-programs else []);
    };
  };
}
