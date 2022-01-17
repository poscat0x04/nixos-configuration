{ pkgs, secrets, ... }:

with secrets.v2ray-server;

{
  services = {
    v2ray = {
      enable = true;
      package = pkgs.v2ray.override {
        assets = with pkgs.extra-files.v2ray-rules-dat; [ geoip-dat geosite-dat ];
      };
      config = {
        log = {
          access = "none";
          loglevel = "warning";
        };
        routing = {
          domainStrategy = "IPIfNonMatch";
          domainMatcher = "mph";
          rules = [
            {
              type = "field";
              outboundTag = "blocked";
              protocol = [ "bittorrent" ];
            }
            {
              type = "field";
              domain = [
                "cn"
              ];
              ip = [
                "geoip:cn"
                "geoip:private"
              ];
              outboundTag = "blocked";
            }
            {
              type = "field";
              port = 25;
              outboundTag = "blocked";
            }
            {
              type = "field";
              network = "tcp,udp";
              outboundTag = "out";
            }
          ];
        };
        inbounds = [
          {
            listen = "127.0.0.1";
            port = 47532;
            protocol = "vless";
            tag = "vless-in";
            sniffing = {
              enabled = true;
              metadataOnly = false;
            };
            settings = {
              clients = [
                {
                  inherit id;
                  email = "poscat@poscat.moe";
                }
              ];
              decryption = "none";
            };
            streamSettings = {
              network = "ws";
              security = "none";
              wsSettings = {
                inherit path;
                headers.Host = host;
              };
            };
          }
          {
            listen = "127.0.0.1";
            port = 47531;
            protocol = "vmess";
            tag = "vmess-in";
            sniffing = {
              enabled = true;
              metadataOnly = false;
            };
            settings = {
              clients = [
                {
                  id = id-2;
                  alterId = 0;
                  email = "poscat@mail.poscat.moe";
                }
              ];
              decryption = "none";
            };
            streamSettings = {
              network = "ws";
              security = "none";
              wsSettings = {
                path = path-2;
                header.Host = host;
              };
            };
          }
        ];
        outbounds = [
          {
            protocol = "freedom";
            tag = "out";
          }
          {
            protocol = "blackhole";
            tag = "blocked";
          }
        ];
      };
    };

    nginx.virtualHosts."${host}" = {
      forceSSL = true;
      useACMEHost = "poscat.moe-wildcard";
      listen = [
        {
          addr = "0.0.0.0";
          port = 443;
          ssl = true;
        }
        {
          addr = "0.0.0.0";
          port = 80;
          ssl = false;
        }
      ];
      locations = {
        "/" = {
          proxyPass = "https://mirrors.mit.edu/";
        };
        "${path}" = {
          proxyPass = "http://127.0.0.1:47532";
          proxyWebsockets = true;
          extraConfig = ''
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          '';
        };
        "${path-2}" = {
          proxyPass = "http://127.0.0.1:47531";
          proxyWebsockets = true;
          extraConfig = ''
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          '';
        };
      };
      extraConfig = ''
        add_header Strict-Transport-Security 'max-age=31536000' always;
      '';
    };
  };

  systemd.services.v2ray.serviceConfig.Environment = "V2RAY_VMESS_AEAD_FORCED=false";
}
