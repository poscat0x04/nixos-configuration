# Network configuration for NUC router VM
{ secrets, nixosModules, ... }:
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
  imports = [
    nixosModules.routeupd
  ];

  boot.kernelModules = [
    "ppp_generic"
    "tcp_bbr"
  ];

  boot.kernel.sysctl = {
    "net.ipv4.ip_dynaddr" = "1";
    "net.ipv4.tcp_congestion_control" = "bbr";
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

        defaultroute
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

  networking.firewall.enable = false;

  systemd.network.networks = {
    "11-ignore-wan" = {
      matchConfig.Name = "enp2s3";
      networkConfig.LinkLocalAddressing = "no";
    };

    "12-lan" = {
      matchConfig.Name = "enp2s4";

      addresses = [
        {
          addressConfig = {
            Address = "10.1.20.1/24";
          };
        }
      ];

      networkConfig = {
        DHCPPrefixDelegation = true;
        IPv6SendRA = true;
        IPv6AcceptRA = false;
        DHCPServer = true;
      };

      dhcpServerConfig = {
        PoolSize = 200;
        DefaultLeaseTimeSec = "1d";
        MaxLeaseTimeSec = "7d";
        DNS = "10.1.20.1";
      };

      linkConfig = {
        RequiredForOnline = false;
      };
    };

    "13-upstream" = {
      matchConfig.Name = "enp2s5";

      DHCP = "yes";
      dhcpV4Config = {
        RouteMetric = 20;
        UseDNS = true;
        UseMTU = true;
        UseDomains = true;
      };
      dhcpV6Config = {
        RouteMetric = 20;
      };

      networkConfig = {
        IPv6AcceptRA = true;
        IPv6PrivacyExtensions = "prefer-public";
      };
    };

    "14-ppp" = {
      matchConfig.Type = "ppp";
      DHCP = "ipv6";
      dns = [ "127.0.0.1:53" ];
      networkConfig = {
        IPv6AcceptRA = true;
        KeepConfiguration = "static";
      };
      dhcpV6Config = {
        UseDelegatedPrefix = true;
        RouteMetric = 5;
        WithoutRA = "solicit";
        PrefixDelegationHint = "::/60";
        UseDNS = false;
      };
      ipv6AcceptRAConfig = {
        DHCPv6Client = "always";
        UseDNS = false;
      };
      routes = [
        {
          routeConfig = {
            Destination = "0.0.0.0/0";
            Metric = 5;
          };
        }
        {
          routeConfig = {
            Destination = "0.0.0.0/0";
            Table = "symmetry";
          };
        }
      ] ++ extra-route-config;
    };
  };
}
