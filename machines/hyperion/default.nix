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
    ../../modules/promethus/node.nix
    ../../modules/promethus/smartctl.nix
    ../../modules/promethus/ping.nix
    ../../modules/sing-box
    ./network.nix
    ./services/elasticsearch.nix
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
    ./services/gitolite.nix
    ./services/gitea.nix
    ./services/ocis.nix
    ./services/code-server.nix
    ./services/opentracker.nix
    ./services/docs.nix
    ./services/ipfs.nix
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
