{ config, lib, pkgs, secrets, ... }:

{
  networking = {
    hostName = config.nixos.settings.machine.hostname;
    useDHCP = false;
    useNetworkd = true;
    resolvconf.useLocalResolver = false;
    wireless = {
      enable = true;
      userControlled.enable = true;
      networks = secrets.wireless;
    };
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

    networks.default = rec {
      DHCP = "yes";

      matchConfig.Name = "!docker* virbr* tun* lo";

      networkConfig = {
        IPv6AcceptRA = true;
        IPv6PrivacyExtensions = "yes";
      };
    };

    networks = {
      eth = {
        matchConfig.Name = "eth* ens*";
        dhcpV4Config.RouteMetric = 10;
      };

      wlan = {
        matchConfig.Type = "wlan";
        dhcpV4Config.RouteMetric = 20;
      };

      tun = {
        matchConfig.Name = "tun*";
        linkConfig.Unmanaged = true;
      };
    };
  };
}
