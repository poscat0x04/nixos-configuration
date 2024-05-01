{ networklib, config, ... }:

let
  secrets = builtins.mapAttrs (_: v: v.path) config.sops.secrets;
in {
  sops.secrets = {
    "sing-box/addr" = {};
    "sing-box/sn" = {};
    "sing-box/id" = {};
    "sing-box/shortId" = {};
    "sing-box/publicKey" = {};
  };
  services.sing-box = {
    enable = true;
    settings = {
      log.level = "info";
      inbounds = [
        {
          type = "tun";
          tag = "tun-in";
          interface_name = "tun0";
          inet4_address = "172.19.0.1/30";
          inet6_address = "fdfe:dcba:9876::1/126";
          stack = "gvisor";
          auto_route = false;
          strict_route = false;
          sniff = true;
        }
        {
          type = "mixed";
          tag = "mixed-in";
          listen = "0.0.0.0";
          listen_port = 1080;
          sniff = true;
        }
      ];
      outbounds = [
        {
          type = "direct";
          tag = "direct";
        }
        {
          type = "vless";
          tag = "vless-out";
          server._secret = secrets."sing-box/addr";
          server_port= 443;
          uuid._secret = secrets."sing-box/id";
          flow = "xtls-rprx-vision";
          network = "tcp";
          tls = {
            enabled = true;
            server_name._secret = secrets."sing-box/sn";
            utls = {
              enabled = true;
              fingerprint = "ios";
            };
            reality = {
              enabled = true;
              public_key._secret = secrets."sing-box/publicKey";
              short_id._secret = secrets."sing-box/shortId";
            };
          };
        }
      ];
      route = {
        final = "vless-out";
        default_mark = networklib.wireguard.fwmark;
        rules = [
          {
            geosite = "cn";
            outbound = "direct";
          }
          {
            geoip = "cn";
            outbound = "direct";
          }
        ];
      };
    };
  };

  systemd.network.networks."09-sing-box-tun" = {
    matchConfig = {
      Name = "tun0";
      Kind = "tun";
    };
    address = [ "172.19.0.1/30" "fdfe:dcba:9876::1/126" ];
    routes = [
      {
        routeConfig = {
          Gateway = "0.0.0.0";
          Table = "sing-box";
        };
      }
      {
        routeConfig = {
          Gateway = "::";
          Table = "sing-box";
        };
      }
    ];
    routingPolicyRules = [
      {
        routingPolicyRuleConfig = {
          Family = "both";
          Priority = 105;
          Table = "main";
          SuppressPrefixLength = 0;
        };
      }
      {
        routingPolicyRuleConfig = {
          Family = "both";
          Priority = 106;
          Table = "others-direct";
        };
      }
      {
        routingPolicyRuleConfig = {
          Family = "both";
          Priority = 108;
          Table = "sing-box";
          InvertRule = true;
          FirewallMark = networklib.wireguard.fwmark;
        };
      }
    ];
  };

  systemd.services.sing-box.serviceConfig.Slice = "system-noproxy.slice";
}
