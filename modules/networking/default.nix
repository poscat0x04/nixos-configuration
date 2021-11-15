{ config, lib, pkgs, secrets, ... }:

{
  boot.kernel.sysctl = {
    "net.ipv4.conf.all.rp_filter" = 2;
  };

  networking = {
    hostName = config.nixos.settings.machine.hostname;
    useDHCP = false;
    useNetworkd = true;
    resolvconf.useLocalResolver = false;
    timeServers = [
      "ntp.ntsc.ac.cn"
    ];
  };

  services.resolved = {
    dnssec = lib.mkDefault "false";
    extraConfig = ''
      MulticastDNS=no
      CacheFromLocalhost=no
    '';
  };

  systemd.suppressedSystemUnits = [
    "systemd-networkd-wait-online.service"
  ];

  systemd.services."systemd-network-wait-online" = {
    description = "Wait for Network to be Configured";
    documentation = [ "man:systemd-networkd-wait-online.service(8)" ];
    conflicts = [ "shutdown.target" ];
    requires = [ "systemd-networkd.service" ];
    after = [ "systemd-networkd.service" ];
    before = [
      "network-online.target"
      "shutdown.target"
    ];
    wantedBy = [ "network-online.target" ];
    unitConfig = {
      DefaultDependencies = false;
    };
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${config.systemd.package}/lib/systemd/systemd-networkd-wait-online --any";
      RemainAfterExit = true;
    };
  };

  systemd.network = {
    enable = true;

    networks = {
      "10-tun" = {
        matchConfig.Name = "tun*";
        linkConfig.Unmanaged = true;
      };

      "15-trusted-ethernet" = {
        matchConfig = {
          Type = "ether";
          Virtualization = true;
        };

        DHCP = "yes";

        networkConfig = {
          DNSOverTLS = "opportunistic";
        };

        dhcpV4Config = {
          RouteMetric = 10;
          UseDNS = true;
          UseMTU = true;
        };
      };

      "20-ethernet" = {
        matchConfig.Type = "ether";

        DHCP = "yes";
        dns = [
          "127.0.0.1:53"
        ];

        dhcpV4Config = {
          RouteMetric = 10;
          UseDNS = false;
          UseMTU = true;
        };

        dhcpV6Config = {
          RouteMetric = 10;
          UseDNS = false;
          UseNTP = false;
        };

        ipv6AcceptRAConfig = {
          UseDNS = false;
        };
      };

      "23-unmanage-ac1200" = {
        matchConfig.Driver = "mt76x2u";
        linkConfig.Unmanaged = true;
      };

      "24-tursted-wireless" = {
        matchConfig = {
          Type = "wlan";
          SSID = builtins.concatStringsSep " " secrets.trusted-wireless-networks;
        };

        DHCP = "yes";

        dhcpV4Config = {
          RouteMetric = 20;
          UseDNS = true;
          UseMTU = true;
          UseDomains = true;
        };

        dhcpV6Config = {
          RouteMetric = 20;
          UseDNS = true;
        };

        networkConfig = {
          IPv6AcceptRA = true;
          IPv6PrivacyExtensions = "prefer-public";
        };
      };

      "25-wireless" = {
        matchConfig.Type = "wlan";

        dns = [
          "127.0.0.1:53"
        ];
        DHCP = "ipv4";

        dhcpV4Config = {
          RouteMetric = 20;
          UseDNS = false;
          UseNTP = false;
          UseMTU = true;
        };

        dhcpV6Config = {
          RouteMetric = 20;
          UseDNS = false;
          UseNTP = false;
        };

        networkConfig = {
          IPv6AcceptRA = false;
        };
      };

      # Brings up the rest interfaces
      "99-fallback" = {
        matchConfig.Name = "!lo";
      };
    };
  };
}
