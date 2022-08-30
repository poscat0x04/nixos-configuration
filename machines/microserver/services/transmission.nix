{ ... }:

{
  services = {
    transmission = {
      enable = true;
      user = "poscat";
      group = "users";
      home = "/shares/poscat/Torrents";
      settings = {
        download-queue-size = 10;
        umask = 18;
        incomplete-dir = "/shares/poscat/Torrents/.incomplete";
        download-dir = "/shares/poscat/Torrents";
        peer-socket-tos = "lowcost";
        speed-limit-up-enabled = false;

        ratio-limit = 1.4;
        ratio-limit-enabled = true;

        rpc-authentication-required = true;
        rpc-username = "poscat";
        rpc-password = "Victor142857";
        rpc-host-whitelist-enabled = false;
        rpc-whitelist-enabled = false;
      };
    };

    nginx = {
      virtualHosts."tr.poscat.moe" = {
        onlySSL = true;
        useACMEHost = "poscat.moe-wildcard";
        listen = [
          {
            addr = "0.0.0.0";
            port = 8443;
            ssl = true;
          }
        ];
        locations = {
          "/" = {
            proxyPass = "http://localhost:9091";
            extraConfig = ''
              proxy_set_header X-Real-IP $remote_addr;
              proxy_set_header X-Forwarded-Host $host;
              proxy_set_header X-Forwarded-Server $host;
              proxy_pass_header X-Transmission-Session-Id;
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

  systemd.services.transmission.serviceConfig.Slice = "system-special-noproxy.slice";
}
