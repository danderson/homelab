{ config, pkgs, flakes, lib, ... }: let
  gpu = config.my.gpu;
  want = gpu != "none";
  glPackages = builtins.getAttr gpu {
    amd = [ pkgs.amdvlk ];
    intel = [];
    none = [];
  };
  drivers = builtins.getAttr gpu {
    amd = ["amdgpu"];
    intel = [];
    none = [];
  };
in lib.mkIf want {
  hardware.opengl.extraPackages = glPackages;
  services.xserver.videoDrivers = drivers;
}
