{ secrets, networklib, nixosModules, ... }:

{
  imports = [ nixosModules.routeupd ];

  networking.pppoe = {
    enable = true;
    underlyingIF = "enp2s1";
    user = secrets.pppoe.china_unicom.user;
    password = secrets.pppoe.china_unicom.password;
  };

  systemd.network.networks = {
    "11-ignore-wan" = networklib.makeWANConfig {ifname = "enp2s1";};

    "12-lan" = networklib.makeTrustedDHCPConfig {metric = 20;} // {
      matchConfig.Name = "enp2s2";
    };

    "13-ppp" = networklib.makePPPConfig {metric = 5;};
  };

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
            nat.masquerade = true;
          };
        };
      };
    };
  };
}
