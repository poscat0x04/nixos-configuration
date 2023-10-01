{...}:

{
  imports = [
    ./hardware-configuration.nix
    ../../profiles/server.nix
    ../../hardware/profiles/uefi.nix
    ../../hardware/cpu/intel
    ../../modules/unbound.nix
    ../../modules/postgresql.nix
    ../../modules/redis.nix
    ../../modules/vlmcsd.nix
    ../../modules/minecraft.nix
    ./network.nix
    ./services/znc.nix
    ./services/mtproto.nix
    ./services/journal.nix
    ./services/vaultwarden.nix
    ./services/transmission.nix
    ./services/attic.nix
    ./services/samba.nix
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
