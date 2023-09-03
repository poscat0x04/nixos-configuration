{ pkgs, secrets, ... }:

{
  imports = [ ../../../modules/nginx.nix ];

  services = {
    vaultwarden = {
      enable = true;
      dbBackend = "postgresql";
      config = {
        databaseUrl = "postgresql://vaultwarden@%2frun%2fpostgresql/vaultwarden";
        webVaultEnabled = true;
        websocketEnabled = true;
        websocketAddress = "127.0.0.1";
        disableAdminToken = true;
        domain = "https://vault.poscat.moe:8443";
        rocketAddress = "127.0.0.1";
        rocketPort = "34817";
        smtpHost = "mail.poscat.moe";
        smtpFrom = "no-reply@poscat.moe";
        smtpFromName = "vaultwarden";
        smtpSecurity = "starttls";
        smtpUsername = "vaultwarden";
        smtpPassword = "${secrets.vaultwarden-smtp-password}";
        signupsVerify = true;
        orgCreationUsers = "poscat@poscat.moe";
        showPasswordHint = false;
        logLevel = "warn";
      };
    };

    nginx = {
      additionalModules = [ pkgs.nginxModules.http-digest-auth ];
      virtualHosts."vault.poscat.moe" = {
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
        locations = {
          "/" = {
            proxyPass = "http://localhost:34817";
            extraConfig = ''
              proxy_set_header X-Real-IP $remote_addr;
            '';
          };
          "/notifications/hub" = {
            proxyPass = "http://localhost:3012";
            proxyWebsockets = true;
            extraConfig = ''
              proxy_set_header X-Real-IP $remote_addr;
            '';
          };
          "/notifications/hub/negotiate" = {
            proxyPass = "http://localhost:34817";
            extraConfig = ''
              proxy_set_header X-Real-IP $remote_addr;
            '';
          };
          "/admin" = {
            proxyPass = "http://localhost:34817";
            extraConfig = ''
              auth_digest_user_file ${secrets.http-password-digest};
              auth_digest 'vaultwarden admin';
              proxy_set_header X-Real-IP $remote_addr;
            '';
          };
        };
        extraConfig = ''
          error_page 497 301 =307 https://$host:$server_port$request_uri;
          add_header Strict-Transport-Security 'max-age=31536000' always;
        '';
      };
    };
  };

  networking.firewall.allowedTCPPorts = [ 8443 ];
  networking.firewall.allowedUDPPorts = [ 8443 ];
}
