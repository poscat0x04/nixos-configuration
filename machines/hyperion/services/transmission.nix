{ pkgs, ... }:

{
  services = {
    transmission = {
      enable = true;
      user = "poscat";
      group = "users";
      home = "/share/torrents/Transmission";
      openPeerPorts = true;
      settings = {
        download-queue-size = 10;
        umask = 18;
        incomplete-dir = "/share/torrents/Transmission/.incomplete";
        download-dir = "/share/torrents/Transmission";
        peer-socket-tos = "lowcost";
        speed-limit-up-enabled = false;

        ratio-limit = 1.4;
        ratio-limit-enabled = true;

        rpc-host-whitelist-enabled = false;
        rpc-whitelist-enabled = false;
        rpc-bind-address = "127.0.0.1";
      };
    };

    nginx = {
      virtualHosts."transmission.poscat.moe" = {
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
          proxyPass = "http://localhost:9091";
          recommendedProxySettings = true;
          extraConfig = ''
            access_by_lua_block {
              local opts = {
                redirect_uri_path = "/callback",
                discovery = "https://git.poscat.moe:8443/.well-known/openid-configuration",
                client_id = "c7352e25-4e47-4240-b8d1-d3518db43762",
                client_secret = secret.transmission_client_secret,
                ssl_verify = "yes",
                scope = "openid email profile groups",
                redirect_uri_scheme = "https",
              }

              local res, err = require("resty.openidc").authenticate(opts)

              if err then
                ngx.status = 500
                ngx.say(err)
                ngx.exit(ngx.HTTP_INTERNAL_SERVER_ERROR)
              end

              if res.user.preferred_username ~= "poscat" then
                ngx.status = 403
                ngx.exit(ngx.HTTP_FORBIDDEN)
                ngx.say('Access Denied')
              end

              ngx.req.set_header("X-USER", res.id_token.sub)
            }
          '';
        };
        extraConfig = ''
          error_page 497 301 =307 https://$host:$server_port$request_uri;
          add_header Strict-Transport-Security 'max-age=31536000' always;
        '';
      };
    };
  };

  systemd.services.transmission.serviceConfig.Slice = "system-noproxy.slice";
}
