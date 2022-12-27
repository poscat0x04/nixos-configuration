# Network configuration for NUC router VM
{
  boot.kernelModules = [
    "ppp_generic"
    "tcp_bbr"
  ];

  boot.kernel.sysctl = {
    "net.ipv4.ip_dynaddr" = "1";
    "net.ipv4.tcp_congestion_control" = "bbr";
  };

  systemd.network.networks = {
    "11-ignore-wan" = {
      matchConfig.Name = "enp2s3";
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
      matchConfig.name = "ppp0";
    };
  };
}
