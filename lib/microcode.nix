{config, lib, ...}:
{
  options = {
    my.cpu-vendor = lib.mkOption {
      type = lib.types.enum ["none" "intel" "amd"];
      default = "none";
    };
  };

  config = {
    hardware.cpu.intel.updateMicrocode = (config.my.cpu-vendor == "intel");
    hardware.cpu.amd.updateMicrocode = (config.my.cpu-vendor == "amd");
  };
}
