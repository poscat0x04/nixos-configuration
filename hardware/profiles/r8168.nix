{ config, ... }:

{
  boot = {
    extraModulePackages = [
      config.boot.kernelPackages.r8168
    ];
    blacklistedKernelModules = [
      "r8169"
    ];
  };
}
