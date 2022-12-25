{ config, ... }: {
  hardware.cpu.intel.updateMicrocode = (config.my.cpu-vendor == "intel");
  hardware.cpu.amd.updateMicrocode = (config.my.cpu-vendor == "amd");
}
