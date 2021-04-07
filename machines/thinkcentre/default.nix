{ lib, ... }:

{
  imports = [
    ../../profiles/default.nix
    ../../profiles/desktop.nix
    ../../hardware/profiles/uefi.nix
    ../../hardware/profiles/laptop.nix
    ../../hardware/profiles/intel.nix
    ../../hardware/profiles/r8168.nix
    ../../hardware/gpu/nvidia
    ../../modules/shared-user.nix
    ./hardware-configuration.nix
  ];

  nixos.settings = {
    system.user = "poscat";
    machine = {
      hostname = "thinkcentre";
      undervolt = rec {
        core = -140;
        gpu = -140;
      };
    };
  };

  hardware.nvidia.prime = {
    intelBusId = "PCI:0:2:0";

    nvidiaBusId = "PCI:1:0:1";
  };

  services.xserver.displayManager.autoLogin.enable = lib.mkForce false;

  networking.hostId = "12345678";

  networking.wireless.enable = lib.mkForce false;

  system.stateVersion = "20.09";
}
