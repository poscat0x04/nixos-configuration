{ networklib, ... }:

{
  services.unbound.additionalInterfaces = [ "10.1.10.1" ];

  systemd.network.networks = {
    "11-ignore-wan" = networklib.makeWANConfig {ifname = "enp2s2";};

    "12-lan" = networklib.makeLanConfig {
      ifname = "enp2s3";
      addr = "10.1.10.1";
    };

    "13-upstream" = networklib.makeTrustedDHCPConfig {metric = 20;} // {
      matchConfig.Name = "enp2s4";
    };
  };
}
