{ pkgs, ... }: {
  services.xserver.windowManager.i3 = {
    enable = true;
    extraSessionCommands = "";
  };
  environment.systemPackages = with pkgs; [
    dmenu
    alacritty
    xss-lock
  ];
}
