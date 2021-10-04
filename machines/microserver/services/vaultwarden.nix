{ pkgs, secrets, ... }:

{
  services = {
    vaultwarden = {
      enable = true;
      dbBackend = "postgresql";
      config = {
        databaseUrl = "postgresql://vaultwarden@localhost/vault";
        webVaultEnabled = true;
        websocketEnabled = true;
        websocketAddress = "127.0.0.1";
        disableAdminToken = true;
        domain = "https://vault.poscat.moe:8443";
        rocketAddress = "127.0.0.1";
        rocketPort = "34817";
        smtpHost = "mail.poscat.moe";
        smtpFrom = "vault@mail.poscat.moe";
        smtpFromName = "vaultwarden";
        smtpSsl = true;
        smtpUsername = "vault@mail.poscat.moe";
        smtpPassword = "${secrets.vaultwarden-smtp-password}";
      };
    };

    nginx = {
      additionalModules = [ pkgs.nginxModules.http-digest-auth ];
      virtualHosts."vault.poscat.moe" = {
        forceSSL = true;
        useACMEHost = "poscat.moe";
        listen = [
          {
            addr = "0.0.0.0";
            port = 8443;
            ssl = true;
          }
        ];
        locations = {
          "/" = {
            proxyPass = "http://localhost:34817";
          };
          "/notifications/hub" = {
            proxyPass = "http://localhost:3012";
            proxyWebsockets = true;
          };
          "/notifications/hub/negotiate" = {
            proxyPass = "http://localhost:34817";
          };
          "/admin" = {
            proxyPass = "http://localhost:34817";
            extraConfig = ''
              auth_digest_user_file ${secrets.http-password-digest};
              auth_digest 'vaultwarden admin';
            '';
          };
        };
      };
    };
  };
}
