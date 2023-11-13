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
    ../../modules/promethus/node.nix
    ../../modules/promethus/smartctl.nix
    ./network.nix
    ./services/znc.nix
    ./services/mtproto.nix
    ./services/journal.nix
    ./services/vaultwarden.nix
    ./services/transmission.nix
    ./services/rtorrent.nix
    ./services/attic.nix
    ./services/samba.nix
    ./services/stunnel.nix
    ./services/prometheus.nix
    ./services/grafana.nix
    ./services/code-server.nix
  ];

  nixos.settings = {
    system.user = "poscat";
    machine.hostname = "hyperion";
  };

  boot.supportedFilesystems = [ "zfs" ];
  networking.hostId = "a6b7ab53";

  services.prometheus.exporters.smartctl.devices = [ "/dev/disk/by-id/ata-HGST_HUS728T8TALE6L4_VRGNZV8K" ];

  # vmware tools
  virtualisation.vmware.guest = {
    enable = true;
    headless = true;
  };

  system.stateVersion = "22.11";
}
