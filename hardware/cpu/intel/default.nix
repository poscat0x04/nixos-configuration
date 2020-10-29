{ config, pkgs, lib, ... }:

{
  imports = [
    ../../../modules/intel-undervolt.nix
  ];

  environment.systemPackages = with pkgs; [ pcm config.boot.kernelPackages.intel-speed-select ];

  hardware = {
    cpu.intel.updateMicrocode = true;
    opengl.extraPackages = with pkgs; [ intel-ocl ];
  };
}
