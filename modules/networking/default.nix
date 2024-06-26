# The network configuration shared by all machines
{ config, lib, networklib, pkgs, secrets, ... }:

{
  imports = [
    ./ip-forward.nix
    ./pppoe.nix
    ./firewall.nix
  ];

  boot= {
    # Load bbr kernel module
    kernelModules = [ "tcp_bbr" ];
    kernel.sysctl = {
      # Enable loose mode reverse filtering, that is, incoming packets will have their sources
      # checked, if the source ip is unreachable from any interface, then it is dropped.
      "net.ipv4.conf.all.rp_filter" = 2;
      # Always enable dynamic address suport
      "net.ipv4.ip_dynaddr" = "1";
      # Always use bbr for congestion control
      "net.ipv4.tcp_congestion_control" = "bbr";
    };
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

  # Use resolved only to manage /etc/resolv.conf
  services.resolved = {
    dnssec = lib.mkDefault "false";
    extraConfig = ''
      MulticastDNS=no
      CacheFromLocalhost=no
      DNSStubListener=no
    '';
  };

  # override systemd-networkd-wait-online so that the system is considered online
  # if any interface is online
  systemd.services.systemd-networkd-wait-online = {
    serviceConfig.ExecStart = lib.mkForce [ "" "${config.systemd.package}/lib/systemd/systemd-networkd-wait-online --any" ];
  };

  # A sane default configuration for systemd-networkd
  #
  # The rules are the following:
  # 1. For interfaces whose names start with "tun" we ignore them
  # 2. For ethernet and wireless interfaces, we run DHCP clients on them to try to obtain ip addresses
  # 3. For any other interfaces, we simply bring them up
  systemd.network = {
    enable = true;

    config.routeTables = {
      cn = 25;
      others-direct = 26;
      symmetry = 27;
      warp = 30;
      sing-box = 31;
    };

    networks = {
      # Ignore TUN devices created by VPN software
      "10-tun" = {
        matchConfig.Name = "tun*";
        linkConfig.Unmanaged = true;
      };

      # Always assume ethernet is untrustworthy
      # By default ethernet networks have a higher route metric of 10
      "20-ethernet" = networklib.makeUntrustedDHCPConfig {metric = 10;} // {
        matchConfig.Type = "ether";
      };

      # Trusted wireless networks
      # By default, wireless networks have a route metric of 20
      "24-tursted-wireless" = networklib.makeTrustedDHCPConfig {metric = 20;} // {
        matchConfig = {
          Type = "wlan";
          SSID = builtins.concatStringsSep " " secrets.trusted-wireless-networks;
        };
      };

      "25-wireless" = networklib.makeUntrustedDHCPConfig {metric = 20;} // {
        matchConfig.Type = "wlan";
      };

      # Brings up the rest interfaces
      "99-fallback" = {
        matchConfig.Name = "!lo";
        linkConfig.RequiredForOnline = false;
      };
    };
  };

  systemd.slices = {
    "system-noproxy" = {
      description = "Slice for services that should not be affected by proxy";
    };
  };

  #systemd.services.systemd-networkd.serviceConfig.Environment = [ "SYSTEMD_LOG_LEVEL=debug" ];
}
