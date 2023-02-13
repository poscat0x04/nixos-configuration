{ secrets, networklib, nixosModules, ... }:

{
  imports = [
    nixosModules.routeupd
  ];

  networking.forward = true;

  services.unbound.additionalInterfaces = [ "10.1.10.1" ];

  networking.pppoe = {
    enable = true;
    underlyingIF = "enp2s2";
    user = secrets.pppoe.china_unicom.user;
    password = secrets.pppoe.china_unicom.password;
  };

  services.routeupd = {
    enable = true;
    interface = "ppp0";
    table = 25;
  };

  systemd.network.networks = {
    "11-ignore-wan" = networklib.makeWANConfig {ifname = "enp2s2";};

    "12-lan" = networklib.makeLanConfig {
      ifname = "enp2s3";
      addr = "10.1.10.1";
    };

    "13-upstream" = networklib.makeTrustedDHCPConfig {metric = 20;} // {
      matchConfig.Name = "enp2s4";
    };
  };

  networking = {
    firewall = {
      trustedInterfaces = [ "ens35" "ens36" ];
      logRefusedConnections = false;
    };
    fwng = {
      flowtable.devices = [ "ens35" "ens36" ];
      nat.enable = true;
      nat66.enable = true;
      nftables-service = {
        ppp0-rules = {
          description = "Set up nftables rules (forwarding, filtering) when ppp0 is created";
          deviceMode = {
            enable = true;
            interface = "ppp0";
            offload = true;
            nat.masquerade = true;
          };
        };
      };
    };
  };
}
