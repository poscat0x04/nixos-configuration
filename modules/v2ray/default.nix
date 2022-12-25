{ secrets, lib, pkgs, config, ... }:


{
  services.v2ray = {
    enable = true;
    config = {
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
              "geosite:apple"
              "geosite:google-cn"
              "geosite:category-games@cn"
              "geosite:cn"
              "domain:springer.com"
              "domain:dl.acm.org"
              "domain:wiley.com"
              "domain:sciencedirect.com"
              "domain:hath.network"
              "domain:hitomi.la"
              "domain:kemono.party"
              "domain:koushoku.org"
              "domain:i3.nhentai.net"
              "domain:pximg.net"
              "domain:ustc.edu.cn"
              "domain:rateyourmusic.com"
              "domain:taobao.com"
              "domain:sharepoint.com"
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
                address = "2606:4700:3031::ac43:85c4";
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
          streamSettings = {
            sockopt = {
              mark = 255;
            };
          };
        }
        {
          protocol = "blackhole";
          tag = "blocked";
        }
      ];
    };
    package = pkgs.v2ray.override {
      assets = with pkgs.extra-files.v2ray-rules-dat; [ geoip-dat geosite-dat ];
    };
  };

  systemd.services.v2ray.serviceConfig.Slice = "system-special-noproxy.slice";
}
