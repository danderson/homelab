{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    irssi
  ];
}
