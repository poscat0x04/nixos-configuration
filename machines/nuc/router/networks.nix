# Network configuration for NUC router VM
{ config, secrets, nixosModules, networklib, ... }:

{
  imports = [
    nixosModules.cloudflare-ddns
    nixosModules.routeupd
    ./wg.nix
  ];

  # Enable IP forwarding
  networking.forward = true;

  networking.pppoe = {
    enable = true;
    underlyingIF = "enp2s3";
    user = secrets.pppoe.china_telecom.user;
    password = secrets.pppoe.china_telecom.password;
  };

  services.routeupd = {
    enable = true;
    interface = "ppp0";
    table = 25;
  };

  systemd.network.networks = {
    "11-ignore-wan" = networklib.makeWANConfig {ifname = "enp2s3";};

    "12-lan" = networklib.makeLanConfig {
      ifname = "enp2s4";
      addr = "10.1.20.1";
    };

    "13-upstream" = networklib.makeTrustedDHCPConfig {metric = 20;} // {
      matchConfig.Name = "enp2s5";
    };

    "14-ppp" = networklib.makePPPConfig {metric = 5;};
  };

  # DDNS
  sops.secrets.cloudflare-auth-token = {};
  services.cloudflare-ddns = {
    enable = true;
    bindToInterface = true;
    tokenPath = config.sops.secrets.cloudflare-auth-token.path;
    config = {
      name = "nuc.poscat.moe";
      interface = "ppp0";
      zoneId = "87cc420fd7bc4eada2b956854578ae8e";
      ipv4 = false;
    };
  };
  systemd.services.cloudflare-ddns.serviceConfig.Slice = "system-noproxy.slice";

  # WARP
  networking.warp = {
    v6addr = "2606:4700:110:857c:de77:ab8d:f751:28f8";
  };
  #networking.fwng.warpId = "0x033573";
}
