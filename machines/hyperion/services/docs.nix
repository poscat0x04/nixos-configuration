{ ... }:

{
  services.nginx = {
    virtualHosts."docs.poscat.moe" = {
      onlySSL = true;
      useACMEHost = "poscat.moe-wildcard";
      kTLS = true;
      listen = [
        {
          addr = "0.0.0.0";
          port = 8443;
          ssl = true;
        }
        {
          addr = "[::0]";
          port = 8443;
          ssl = true;
        }
      ];
      locations."/" = {
        proxyPass = "http://10.1.10.4:80/docs/";
        recommendedProxySettings = true;
        extraConfig = ''
          proxy_redirect http://10.1.10.4:80/docs/ /;
        '';
      };
      locations."~* \\.png$" = {
        proxyPass = "http://10.1.10.4:80";
        recommendedProxySettings = true;
      };
      extraConfig = ''
        error_page 497 301 =307 https://$host$request_uri;
        add_header Strict-Transport-Security 'max-age=31536000' always;
      '';
    };
  };
}
