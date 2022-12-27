# Network configuration for NUC router VM
{ secrets, ... }:
{
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
      autostart = false;
    };
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
        DHCPServer = true;
      };

      dhcpServerConfig = {
        PoolSize = 200;
        DefaultLeaseTimeSec = "1d";
        MaxLeaseTimeSec = "7d";
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
            Type = "unicast";
            Metric = 5;
          };
        }
      ];
    };
  };
}
