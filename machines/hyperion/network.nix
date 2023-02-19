{ config, secrets, networklib, nixosModules, ... }:

{
  imports = [
    nixosModules.routeupd
    nixosModules.cloudflare-ddns
    ../../modules/sops-nix.nix
  ];

  networking.pppoe = {
    enable = true;
    underlyingIF = "enp2s1";
    user = secrets.pppoe.china_unicom.user;
    password = secrets.pppoe.china_unicom.password;
  };

  # networkd
  systemd.network.networks = {
    "11-ignore-wan" = networklib.makeWANConfig {ifname = "enp2s1";};

    "12-lan" = networklib.makeTrustedDHCPConfig {metric = 20;} // {
      matchConfig.Name = "enp2s2";
    };

    "13-ppp" = networklib.makePPPConfig {metric = 5;};
  };

  # firewall
  networking = {
    firewall = {
      trustedInterfaces = [ "ens34" ];
      logRefusedConnections = false;
    };
    fwng = {
      flowtable.devices = [ "ens34" ];
      nat.enable = true;
      nat66.enable = true;
      nftables-service = {
        ppp0-rules = {
          description = "Set up nftables rules (forwarding, filtering) when ppp0 is created";
          deviceMode = {
            enable = true;
            interface = "ppp0";
            offload = true;
            mark = "1000";
            nat.masquerade = true;
          };
        };
      };
    };
  };

  # DDNS
  sops.secrets.cloudflare-auth-token = {};
  services.cloudflare-ddns = {
    enable = true;
    bindToInterface = true;
    tokenPath = config.sops.secrets.cloudflare-auth-token.path;
    config = {
      name = "hyperion.poscat.moe";
      interface = "ppp0";
      zoneId = "87cc420fd7bc4eada2b956854578ae8e";
    };
  };
  systemd.services.cloudflare-ddns.serviceConfig.Slice = "system-noproxy.slice";
}
