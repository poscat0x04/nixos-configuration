{ config, secrets, networklib, nixosModules, ... }:

{
  imports = [
    nixosModules.routeupd
    nixosModules.cloudflare-ddns
    ../../modules/networking/warp.nix
  ];

  networking.pppoe = {
    enable = true;
    underlyingIF = "enp2s1";
    user = secrets.pppoe.china_unicom.user;
    password = secrets.pppoe.china_unicom.password;
  };

  # update routing table
  services.routeupd = {
    enable = true;
    interface = "ppp0";
    table = 25;
  };

  # networkd
  systemd.network.networks = {
    "11-ignore-wan" = networklib.makeWANConfig {ifname = "enp2s1";};

    "12-lan" = {
      matchConfig.Name = "enp2s2";
      DHCP = "no";
      addresses = [ {addressConfig.Address = "10.1.10.3/24";} ];
      routes = [
        {
          routeConfig = {
            Destination = "0.0.0.0/0";
            Metric = 20;
            Scope = "global";
            Gateway = "10.1.10.1";
          };
        }
        {
          routeConfig = {
            Destination = "10.1.20.0/24";
            Scope = "site";
            Gateway = "10.1.10.1";
            PreferredSource = "10.1.10.3";
          };
        }
        {
          routeConfig = {
            Destination = "10.1.100.0/24";
            Scope = "site";
            Gateway = "10.1.10.1";
            PreferredSource = "10.1.10.3";
          };
        }
      ];
      networkConfig.IPv6AcceptRA = true;
      ipv6AcceptRAConfig.RouteMetric = 20;
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
            mark = builtins.toString networklib.wireguard.fwmark;
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
      ipv6 = false;
    };
  };
  systemd.services.cloudflare-ddns.serviceConfig.Slice = "system-noproxy.slice";

  # WARP
  networking.warp = {
    manualActivation = true;
    v6addr = "2606:4700:110:889f:69da:797a:1461:a409";
  };
  networking.fwng.warpId = "0x5440ec";
}
