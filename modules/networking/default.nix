# The network configuration shared by all machines
{ config, lib, pkgs, secrets, ... }:

{
  # Enable loose mode reverse filtering, that is, incoming packets will have their sources
  # checked, if the source ip is unreachable from any interface, then it is dropped.
  boot.kernel.sysctl = {
    "net.ipv4.conf.all.rp_filter" = 2;
  };

  networking = {
    # Use the hostname configured in nixos.settings.machine
    hostName = config.nixos.settings.machine.hostname;
    domain = "home.arpa";

    # We use systemd-networkd solely to manage out networks
    useDHCP = false;
    useNetworkd = true;

    # Use NTSC's NTP service by default since most of my machines are located in China
    timeServers = [
      "ntp.ntsc.ac.cn"
    ];
  };

  # Use systemd-resolved as a pure stub resolver
  services.resolved = {
    dnssec = lib.mkDefault "false";
    extraConfig = ''
      MulticastDNS=no
      CacheFromLocalhost=no
    '';
  };

  # Replace systemd-networkd-wait-online.service with a custom service
  # that finishes starting as soon as one interface is up.
  #
  # Also blocks the starting of network-online.target
  #
  # TODO: support the ability to customize the interface to listen to.
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

  # A sane default configuration for systemd-networkd
  #
  # The rules are the following:
  # 1. For interfaces whose names start with "tun" we ignore them
  # 2. For ethernet and wireless interfaces, we run DHCP clients on them to try to obtain ip addresses
  # 3. For any other interfaces, we simply bring them up
  systemd.network = {
    enable = true;

    networks = {
      # Ignore TUN devices created by VPN software
      "10-tun" = {
        matchConfig.Name = "tun*";
        linkConfig.Unmanaged = true;
      };

      # Always assume ethernet is untrustworthy
      # By default ethernet networks have a higher route metric of 10
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

      # Trusted wireless networks
      # By default, wireless networks have a route metric of 20
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

  systemd.slices = {
    "system-special" = {
      #wantedBy = [ "multi-user.target" ];
      description = "Special system slices";
    };

    "system-special-noproxy" = {
      #wantedBy = [ "multi-user.target" ];
      description = "Slice for services that should not be affected by transparent proxy";
    };
  };
}
