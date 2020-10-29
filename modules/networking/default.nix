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

  systemd.network = {
    enable = true;

    networks.default = rec {
      DHCP = "yes";

      matchConfig.Name = "!docker* virbr* tun*";

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
