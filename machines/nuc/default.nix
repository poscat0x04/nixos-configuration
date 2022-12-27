{...}:

{
  imports = [
    ./hardware-configuration.nix
    ../../profiles/server.nix
    ../../hardware/profiles/uefi.nix
    ../../hardware/cpu/intel
  ];

  nixos.settings = {
    system.user = "poscat";
    machine.hostname = "nuc";
  };

  virtualisation.vmware.guest = {
    enable = true;
    headless = true;
  };

  system.stateVersion = "21.11";
}
