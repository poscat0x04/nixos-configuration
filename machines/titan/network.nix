{ config, secrets, networklib, nixosModules, ... }:

{
  imports = [
    nixosModules.routeupd
    nixosModules.cloudflare-ddns
    ../../modules/networking/warp.nix
    ./wg.nix
  ];

  networking.forward = true;

  services.unbound.additionalInterfaces = [ "10.1.10.1" ];

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

    "12-lan" = networklib.makeLanConfig {
      ifname = "enp2s2";
      addr = "10.1.10.1";
    };

    "13-upstream" = networklib.makeTrustedDHCPConfig {metric = 20;} // {
      matchConfig.Name = "enp2s3";
    };

    "14-ppp" = networklib.makePPPConfig {metric = 5;};
  };

  # firewalls
  networking = {
    firewall = {
      trustedInterfaces = [ "ens34" "ens35" ];
      logRefusedConnections = false;
    };
    fwng = {
      flowtable.devices = [ "ens34" "ens35" ];
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
      name = "titan.poscat.moe";
      interface = "ppp0";
      zoneId = "87cc420fd7bc4eada2b956854578ae8e";
      ipv6 = false;
    };
  };
  systemd.services.cloudflare-ddns.serviceConfig.Slice = "system-noproxy.slice";

  # WARP
  networking.warp.v6addr = "2606:4700:110:8f0e:aae0:595e:676:c3c2";
  networking.fwng.warpId = "0xde98d0";
}
