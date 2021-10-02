{ nixosModules, secrets, ... }:

{
  imports = [
    nixosModules.cloudflare-ddns
  ];

  services.cloudflare-ddns = {
    enable = true;
    domain = secrets.ddns-domain;
    interface = "ppp0";
    zoneId = secrets.cloudflare-zone-id;
    dualstack = true;
    ttl = 60;
    token = secrets.ddns-cloudflare-token;
  };

  systemd.services.cloudflare-ddns = {
    after = [ "ppp-wait-online.service" ];
    requires = [ "ppp-wait-online.service" ];
  };
}
