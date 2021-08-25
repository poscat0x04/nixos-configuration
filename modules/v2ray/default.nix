{ secrets, lib, pkgs, config, ... }:

with lib;

{
  options = {
    services.v2ray.overlay = mkOption {
      type = types.functionTo (types.attrsOf types.unspecified);
      default = x: x;
    };
  };

  config = {
    services.v2ray = {
      enable = true;
      config = config.services.v2ray.overlay {
        log = {
          loglevel = "warning";
        };
        routing = {
          domainStrategy = "IPIfNonMatch";
          domainMatcher = "mph";
          rules = [
            {
              type = "field";
              domain = [
                "geosite:category-ads-all"
              ];
              outboundTag = "blocked";
            }
            {
              type = "field";
              domain = [
                "geosite:apple-cn"
                "geosite:google-cn"
                "geosite:category-games@cn"
                "geosite:cn"
              ];
              outboundTag = "direct";
            }
            {
              type = "field";
              ip = [
                "geoip:cn"
                "geoip:private"
              ];
              outboundTag = "direct";
            }
            {
              type = "field";
              protocol = [
                "bittorrent"
              ];
              outboundTag = "direct";
            }
            {
              type = "field";
              network = "tcp,udp";
              outboundTag = "proxy";
            }
          ];
        };
        inbounds = [
          {
            protocol = "dokodemo-door";
            tag = "transparent";
            listen = "127.0.0.1";
            port = 5768;
            settings = {
              followRedirect = true;
              network = "tcp,udp";
            };
            streamSettings = {
              tproxy = "tproxy";
              mark = 255;
            };
            sniffing = {
              enabled = true;
              metadataOnly = false;
            };
          }
          {
            protocol = "socks";
            tag = "socks";
            listen = "127.0.0.1";
            port = 1080;
            settings = {};
            sniffing = {
              enabled = true;
              metadataOnly = false;
            };
          }
          {
            protocol = "http";
            tag = "http";
            listen = "127.0.0.1";
            port = 8080;
            settings = {};
            sniffing = {
              enabled = true;
              metadataOnly = false;
            };
          }
        ];
        outbounds = with secrets.v2ray-server; [
          {
            protocol = "vless";
            tag = "proxy";
            settings = {
              vnext = [
                {
                  inherit address;
                  port = 443;
                  users = [
                    {
                      inherit id;
                      encryption = "none";
                    }
                  ];
                }
              ];
            };
            streamSettings = {
              network = "ws";
              security = "tls";
              tlsSettings = {
                serverName = host;
              };
              wsSettings = {
                inherit path;
                headers = {
                  Host = host;
                };
              };
              sockopt = {
                mark = 255;
              };
              mux = {
                enable = true;
                concurrency = 4;
              };
            };
          }
          {
            protocol = "freedom";
            tag = "direct";
            settings = {};
            streamSettings = {
              sockopt = {
                mark = 255;
              };
            };
          }
          {
            protocol = "blackhole";
            tag = "blocked";
            settings = {};
          }
        ];
      };
      package = pkgs.v2ray.override {
        assetOverrides = pkgs.extra-files.v2ray-rules-dat;
      };
    };
  };
}
