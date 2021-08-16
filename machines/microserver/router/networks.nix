{ secrets, ... }:

{
  boot.kernelModules = [
    "ppp_generic"
  ];

  boot.kernel.sysctl = {
    "net.ipv4.ip_dynaddr" = "1";
  };

  services.pppd = {
    enable = true;
    peers = {
      china_unicom = {
        config = ''
          plugin pppoe.so
          ifname ppp0
          nic-eno1

          lcp-echo-failure 5
          lcp-echo-interval 1
          maxfail 1

          mru 1492
          mtu 1492

          user ${secrets.pppoe.china_unicom.user}
          password ${secrets.pppoe.china_unicom.password}

          nodefaultroute
        '';
      };
    };
  };

  systemd.network = {
    netdevs = {
      br-lan = {
        netdevConfig = {
          Name = "br-lan";
          Kind = "bridge";
        };
      };
      dummy0 = {
        netdevConfig = {
          Name = "dummy0";
          Kind = "dummy";
        };
      };
    };
    networks = {
      "11-br-lan" = {
        matchConfig.Name = "br-lan";
        linkConfig = {
          MTUBytes = "1492";
        };
        addresses = [
          {
            addressConfig = {
              Address = "10.1.10.1/24";
            };
          }
        ];
      };
      "12-ppp-eth-disable-dhcp" = {
        matchConfig.Name = "eno1";
        linkConfig = {
          Unmanaged = true;
        };
      };
      "13-bind-br" = {
        matchConfig.Name = "eno3 eno4 dummy0";
        networkConfig = {
          Bridge = "br-lan";
        };
        linkConfig = {
          MTUBytes = "1492";
        };
      };
      "14-ppp" = {
        matchConfig = {
          Name = "ppp0";
          Type = "ppp";
        };
        DHCP = "ipv6";
        dns = [
          "127.0.0.1:53"
        ];
        networkConfig = {
          IPv6AcceptRA= true;
        };
        dhcpV6Config = {
          ForceDHCPv6PDOtherInformation = true;
        };
        routes = [
          {
            routeConfig = {
              Destination = "0.0.0.0/0";
              Metric = 5;
            };
          }
        ];
      };
    };
  };
}
