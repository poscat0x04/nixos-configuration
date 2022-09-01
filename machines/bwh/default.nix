{ lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../profiles/server.nix
    ../../modules/acme.nix
    ../../modules/nginx.nix
    ./services/v2ray.nix
    ./services/redis.nix
    ./services/ldap.nix
    ./services/dovecot.nix
    ./services/rspamd.nix
    ./services/postfix.nix
    ./services/tunnel.nix
    ./services/wireguard.nix
  ];

  boot = {
    kernelModules = [
      "ppp_generic"
      "tcp_bbr"
    ];
    kernel.sysctl = {
      "net.ipv4.ip_dynaddr" = "1";
      "net.ipv4.tcp_congestion_control" = "bbr";
    };
    loader.grub = {
      enable = true;
      device = "/dev/sda";
    };
    zfs.enableUnstable = false;
  };

  nixos.settings = {
    system.user = "poscat";
    machine = {
      hostname = "bwh";
    };
  };

  services = {
    zfs.autoScrub.enable = false;
    btrfs.autoScrub.enable = true;
    nginx.virtualHosts.default = {
      forceSSL = true;
      listen = [
        {
          addr = "0.0.0.0";
          port = 443;
          ssl = true;
        }
      ];
      useACMEHost = "poscat.moe-wildcard";
    };
  };

  nix.useMirror = false;

  networking.timeServers = lib.mkForce [
    "time.nist.gov"
    "time.cloudflare.com"
  ];

  networking.firewall.enable = false;

  networking.hostId = "bd66af60";

  system.stateVersion = "21.11";
}
