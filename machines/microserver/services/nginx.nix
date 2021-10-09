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
    recommendedProxySettings = true;

    resolver.addresses = [ "127.0.0.53" ];

    sslCiphers = "ECDHE+AESGCM:DHE+AESGCM";
    sslProtocols = "TLSv1.3";
    eventsConfig = ''
      worker_connections 1024;
    '';
    appendConfig = ''
      worker_processes auto;
    '';
  };

  users.users.nginx.extraGroups = [ "acme" ];
}
