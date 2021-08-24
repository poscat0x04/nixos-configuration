{ nixosModules, ... }:

{
  imports = [
    nixosModules.smartdns-china-domain-list-updater
  ];

  services = {
    smartdns-china-domain-list-updater = {
      enable = true;
    };

    smartdns = {
      enable = true;
      settings = {
        bind = [ "127.0.0.1:53" "[::1]:53" ];
        bind-tcp = [ "127.0.0.1:53" "[::1]:53" ];
        speed-check-mode = "ping,tcp:80";
        cache-persist = true;
        log-level = "warn";
        conf-file = [
          "/var/lib/smartdns-china-domain-list-updater/accelerated-domains.conf"
          "/var/lib/smartdns-china-domain-list-updater/apple.conf"
          "/var/lib/smartdns-china-domain-list-updater/google.conf"
        ];
        server = [
          "114.114.114.114 -group cn -exclude-default-group"
        ];
        server-tls = [
          "dns.alidns.com -group cn -exclude-default-group"
          "101.6.6.6:8853"
        ];
      };
    };
  };

  systemd.services.smartdns = {
    requires = [ "smartdns-china-domain-list-updater.service" ];
    after = [ "smartdns-china-domain-list-updater" ];
  };
}
