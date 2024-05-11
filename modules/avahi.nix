{ ... }:

{
  services.avahi = {
    enable = true;
    ipv6 = true;
    nssmdns4 = true;
    nssmdns6 = true;
    publish = {
      enable = true;
      hinfo = true;
      domain = true;
      addresses = true;
      userServices = true;
    };
  };
}
