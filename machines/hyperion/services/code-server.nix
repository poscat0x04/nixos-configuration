{ ... }:

{
  services.nginx = {
    virtualHosts."code.poscat.moe" = {
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
        proxyPass = "http://10.1.10.4:8023";
        proxyWebsockets = true;
        recommendedProxySettings = true;
        extraConfig = ''
          access_by_lua_block {
            local opts = {
              redirect_uri_path = "/callback",
              discovery = "https://git.poscat.moe/.well-known/openid-configuration",
              client_id = "bda9d2e6-a344-4769-b121-f1308cecb191",
              client_secret = secret.code_client_secret,
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
        error_page 497 301 =307 https://$host$request_uri;
        add_header Strict-Transport-Security 'max-age=31536000' always;
      '';
    };
  };
}
