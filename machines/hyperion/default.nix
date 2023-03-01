{...}:

{
  imports = [
    ./hardware-configuration.nix
    ../../profiles/server.nix
    ../../hardware/profiles/uefi.nix
    ../../hardware/cpu/intel
    ../../modules/unbound.nix
    ../../modules/postgresql.nix
    ./network.nix
    ./services/mtproto.nix
    ./services/journal.nix
    ./services/genshin-checkin.nix
  ];

  nixos.settings = {
    system.user = "poscat";
    machine.hostname = "hyperion";
  };

  boot.supportedFilesystems = [ "zfs" ];
  networking.hostId = "a6b7ab53";

  # vmware tools
  virtualisation.vmware.guest = {
    enable = true;
    headless = true;
  };

  system.stateVersion = "22.11";
}
