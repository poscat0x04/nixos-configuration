{ config, pkgs, nixosModules, ... }:

{
  imports = [ nixosModules.atticd ];

  sops.secrets.attic-secret = {};

  services = {
    atticd = {
      enable = true;
      credentialsFile = config.sops.secrets.attic-secret.path;
      settings = {
        listen = "127.0.0.1:20843";
        allowed-hosts = [ "cache.poscat.moe" "attic.poscat.moe" ];
        api-endpoint = "https://attic.poscat.moe:8443/";
        substituter-endpoint = "https://cache.poscat.moe:8443/";
        database.url = "postgresql://atticd@%2frun%2fpostgresql/attic";
        chunking = {
          nar-size-threshold = 64 * 1024;
          min-size = 16 * 1024;
          avg-size = 64 * 1024;
          max-size = 256 * 1024;
        };
        compression = {
          type = "zstd";
          level = 10;
        };
        garbage-collection.default-retention-period = "2 years";
      };
    };

    nginx.virtualHosts = {
      "attic.poscat.moe" = {
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
            proxyPass = "http://127.0.0.1:20843";
            extraConfig = ''
              # disable upload size limit
              client_max_body_size 0;
              proxy_set_header X-Real-IP $remote_addr;
              proxy_set_header Host $host;
            '';
          };
        };
      };
      "cache.poscat.moe" = {
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
            proxyPass = "http://127.0.0.1:20843";
            extraConfig = ''
              proxy_set_header X-Real-IP $remote_addr;
              proxy_set_header Host $host;
            '';
          };
        };
      };
    };
  };

  systemd.services.atticd = {
    requires = [ "postgresql.service" ];
    after = [ "postgresql.service" ];
  };

  environment.systemPackages = [ pkgs.attic-client ];
}
