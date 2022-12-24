{ ... }:

{
  services.squid = {
    enable = true;
    proxyAddress = "10.1.10.1";
  };

  systemd.services.squid.serviceConfig.Slice = "system-special-noproxy.slice";
}
