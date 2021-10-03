{ pkgs, ... }:

{
  services.nginx = {
    enable = true;
    user = "poscat";
    group = "acme";
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
    recommendedProxySettings = true;

    resolver.addresses = [ "127.0.0.1" ];

    sslCiphers = "ECDHE+AESGCM:DHE+AESGCM";
    sslProtocols = "TLSv1.3";
    eventsConfig = ''
      worker_connections 1024;
    '';
    appendConfig = ''
      worker_processes 6;
    '';

    virtualHosts = {
      /*
      "webdav.poscat.moe" = {
      };
      */
    };
  };
}
