{...}:

{
  imports = [
    ./hardware-configuration.nix
    ../../profiles/server.nix
    ../../hardware/profiles/uefi.nix
    ../../hardware/cpu/intel
    ../../modules/unbound.nix
    ../../modules/journal-upload.nix
    ../../modules/promethus/node.nix
    ./network.nix
  ];

  nixos.settings = {
    system.user = "poscat";
    machine.hostname = "titan";
  };

  # vmware tools
  virtualisation.vmware.guest = {
    enable = true;
    headless = true;
  };

  system.stateVersion = "22.11";
}
