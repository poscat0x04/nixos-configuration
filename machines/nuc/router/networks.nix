# Network configuration for NUC router VM
{ secrets, nixosModules, networklib, ... }:
let
  # This should cover all possible genshin (Asian) server IPs
  alibaba-tokyo-ip = [
    "47.74.0.0/18"
    "47.74.32.0/19"
    "47.91.0.0/19"
    "47.91.16.0/20"
    "47.245.0.0/18"
    "47.245.32.0/19"
    "47.245.48.0/20"
    "8.209.192.0/18"
    "8.209.224.0/19"
    "8.211.128.0/18"
  ];
  # additional IP ranges that should not be proxied
  more-direct = [
    # quad101 dns
    "101.101.101.101"
    # dns666
    "101.6.6.6"
    # kemono.party
    "190.115.31.142"
  ];
  extra-route-config = map (ip: {
    routeConfig = {
      Destination = ip;
      Table = "others-direct";
    };
  }) (alibaba-tokyo-ip ++ more-direct);
in {
  imports = [ nixosModules.routeupd ];

  # Enable IP forwarding
  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = true;
    "net.ipv6.conf.all.forwarding" = true;
  };

  services.pppd = {
    enable = true;
    peers.china_unicom = {
      config = ''
        plugin pppoe.so
        ifname ppp0
        nic-enp2s3

        lcp-echo-failure 5
        lcp-echo-interval 1
        maxfail 1

        mru 1492
        mtu 1492

        user ${secrets.pppoe.china_unicom.user}
        password ${secrets.pppoe.china_unicom.password}

      '';
      autostart = true;
    };
  };

  services.routeupd = {
    enable = true;
    interface = "ppp0";
    table = 25;
    dependency = "pppd-china_unicom.service";
  };

  systemd.network.networks = {
    "11-ignore-wan" = networklib.makeWANConfig {ifname = "enp2s3";};

    "12-lan" = networklib.makeLanConfig {
      ifname = "enp2s4";
      addr = "10.1.20.1";
    };

    "13-upstream" = networklib.makeTrustedDHCPConfig {metric = 20;} // {
      matchConfig.Name = "enp2s5";
    };

    "14-ppp" = networklib.makePPPConfig {metric = 5;};
  };
}
