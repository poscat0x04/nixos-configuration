{ ... }:

{
  imports = [
    ../../profiles/desktop.nix
    ../../hardware/profiles/uefi.nix
    ../../hardware/profiles/laptop.nix
    ../../hardware/profiles/intel.nix
    ../../hardware/profiles/thinkpad.nix
    ../../hardware/gpu/nvidia
    ./hardware-configuration.nix
  ];

  hardware.nvidia.prime = {
    intelBusId = "PCI:0:2:0";

    nvidiaBusId = "PCI:2:0:0";
  };

  nixos.settings = {
    system.user = "poscat";
    machine = {
      hostname = "t460p";
      undervolt = rec {
        core = -140;
        gpu = -140;
      };
      dpi = 120;
    };
  };

  networking.hostId = "9481596d";

  system.stateVersion = "20.09";
}
