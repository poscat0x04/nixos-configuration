# Network configuration for NUC router VM
{ secrets, nixosModules, networklib, ... }:

{
  imports = [ nixosModules.routeupd ];

  # Enable IP forwarding
  boot.kernel.sysctl = {
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

      '';
      autostart = true;
    };
  };

  services.routeupd = {
    enable = true;
    interface = "ppp0";
    table = 25;
    dependency = "pppd-china_unicom.service";
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
}
