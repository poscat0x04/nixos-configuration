{ config, pkgs, flakes, ... }:

{
  imports = [ (flakes.attic.path + "/nixos/atticd.nix") ];

  sops.secrets.attic-secret = {};

  services = {
    atticd = {
      enable = true;
      credentialsFile = config.sops.secrets.attic-secret.path;
      useFlakeCompatOverlay = false;
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
        locations."/" = {
          proxyPass = "http://127.0.0.1:20843";
          recommendedProxySettings = true;
          extraConfig = ''
            # disable upload size limit
            client_max_body_size 0;
          '';
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
        locations."/" = {
          proxyPass = "http://127.0.0.1:20843";
          recommendedProxySettings = true;
        };
        extraConfig = ''
          error_page 497 301 =307 https://$host:$server_port$request_uri;
          add_header Strict-Transport-Security 'max-age=31536000' always;
        '';
      };
    };
  };

  systemd.services.atticd = {
    requires = [ "postgresql.service" ];
    after = [ "postgresql.service" ];
  };

  environment.systemPackages = [ pkgs.attic-client ];
}
