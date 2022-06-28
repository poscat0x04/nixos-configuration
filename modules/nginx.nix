{ pkgs, ... }:

{
  services.nginx = {
    enable = true;
    package = pkgs.nginxMainline;
    enableReload = true;
    additionalModules = with pkgs.nginxModules; [
      brotli
      moreheaders
      dav
    ];
    recommendedOptimisation = true;
    recommendedTlsSettings = true;
    recommendedGzipSettings = true;

    commonHttpConfig = ''
      brotli on;
      brotli_types
        application/atom+xml
        application/javascript
        application/json
        application/xml
        application/xml+rss
        image/svg+xml
        text/css
        text/javascript
        text/plain
        text/xml;
    '';

    resolver.addresses = [ "127.0.0.53" ];

    sslCiphers = "ECDHE+AESGCM:DHE+AESGCM";
    sslProtocols = "TLSv1.2 TLSv1.3";
    eventsConfig = ''
      worker_connections 1024;
      use epoll;
      multi_accept on;
    '';
    appendConfig = ''
      worker_processes auto;
      worker_rlimit_nofile 100000;
    '';
    virtualHosts.default = {
      listen = [
        {
          addr = "0.0.0.0";
          port = 80;
        }
      ];
      serverName = "_";
      default = true;
      extraConfig = ''
        return 444;
      '';
    };
  };

  systemd.services.nginx.serviceConfig = {
    LimitNOFILE = "100000";
    Slice = "system-special-noproxy.slice";
  };

  users.users.nginx.extraGroups = [ "acme" ];
}
