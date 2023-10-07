{ config, ... }:

{
  sops.secrets.grafana-smtp-username = {};
  sops.secrets.grafana-smtp-password = {};

  services = {
    grafana = {
      enable = true;
      settings = {
        server = {
          domain = "glass.poscat.moe";
          protocol = "socket";
          enforce_domain = true;
        };
        database = {
          type = "postgres";
          name = "grafana";
          user = "grafana";
          host = "/run/postgresql/";
        };
        remote_cache = {
          type = "redis";
          connstr = "addr=/run/redis/redis.sock,pool_size=100,db=0";
        };
        security = {
          cookie_secure = true;
          angular_support_enabled = false;
        };
        smtp = {
          enabled = true;
          host = "smtp.mail.me.com:587";
          user = "$__file{/run/credentials/grafana.service/smtp-username}";
          password = "$__file{/run/credentials/grafana.service/smtp-password}";
          from_address = "no-reply@poscat.moe";
          from_name = "Grafana";
          startTLS_policy = "MandatoryStartTLS";
        };
        email.welcome_email_on_sign_up = true;
        log = {
          mode = "console";
          level = "warn";
        };
        analytics.reporting_enabled = false;
        external_image_storage.provider = "local";
      };
      provision = {
        enable = true;
        datasources.settings.datasources = [
          {
            name = "Prometheus";
            type = "prometheus";
            access = "proxy";
            url = "http://127.0.0.1:${toString config.services.prometheus.port}";
          }
        ];
      };
    };

    nginx = {
      virtualHosts."glass.poscat.moe" = {
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
            proxyPass = "http://unix:/run/grafana/grafana.sock:";
            recommendedProxySettings = true;
          };
          "/api/live/" = {
            proxyPass = "http://unix:/run/grafana/grafana.sock:";
            proxyWebsockets = true;
          };
        };
        extraConfig = ''
          error_page 497 301 =307 https://$host:$server_port$request_uri;
          add_header Strict-Transport-Security 'max-age=31536000' always;
        '';
      };
    };
  };

  systemd.services = {
    nginx.serviceConfig.SupplementaryGroups = [ "grafana" ];
    grafana.serviceConfig.LoadCredential = [
      "smtp-username:${config.sops.secrets.grafana-smtp-username.path}"
      "smtp-password:${config.sops.secrets.grafana-smtp-password.path}"
    ];
  };
}
