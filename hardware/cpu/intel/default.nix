{ config, pkgs, lib, ... }:

{
  imports = [
    ../../../modules/intel-undervolt.nix
  ];

  boot.kernelParams = [
    # enable IOMMU
    "intel_iommu=on"
    "iommu=pt"
  ];

  environment.systemPackages = with pkgs; [ pcm ];

  hardware = {
    cpu.intel.updateMicrocode = true;
    opengl.extraPackages = with pkgs; [ intel-ocl ];
  };
}
