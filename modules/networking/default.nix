{ config, lib, pkgs, secrets, ... }:

{
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

      "20-ethernet" = {
        matchConfig.Name = "eth* ens*";

        DHCP = "yes";
        dns = [
          "127.0.0.1:53"
        ];

        dhcpV4Config = {
          RouteMetric = 10;
          UseDNS = false;
        };

        dhcpV6Config = {
          RouteMetric = 10;
          UseDNS = false;
          UseNTP = false;
        };
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
        DHCP = "yes";

        dhcpV4Config = {
          RouteMetric = 20;
          UseDNS = false;
          UseNTP = false;
        };

        dhcpV6Config = {
          RouteMetric = 20;
          UseDNS = false;
          UseNTP = false;
        };
      };

      "99-fallback" = {
        matchConfig.Name = "!docker* virbr* tun* lo";

        dns = [
          "127.0.0.1:53"
        ];
        DHCP = "yes";

        dhcpV4Config = {
          UseDNS = false;
          UseNTP = false;
        };

        dhcpV6Config = {
          UseDNS = false;
          UseNTP = false;
        };

        networkConfig = {
          IPv6AcceptRA = true;
          IPv6PrivacyExtensions = "prefer-public";
        };
      };
    };
  };
}
