{ config, pkgs, flakes, lib, ... }: let
  gpu = config.my.gpu;
  want = gpu != "none" && gpu != "intel";
  glPackages = builtins.getAttr gpu {
    amd = [ pkgs.amdvlk ];
    intel = null;
    none = null;
  };
  drivers = builtins.getAttr gpu {
    amd = ["amdgpu"];
    intel = null;
    none = null;
  };
in lib.mkIf want {
  hardware.opengl.extraPackages = glPackages;
  services.xserver.videoDrivers = drivers;
}
