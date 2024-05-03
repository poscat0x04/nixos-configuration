{ networklib, config, ... }:

let
  json = builtins.fromJSON (builtins.readFile ./settings.json);
  settings = json // { outbounds = map (outbound:
      if outbound.type == "wireguard"
      then outbound // { local_address = [ "172.16.0.2/32" "${config.networking.warp.v6addr}/128" ]; }
      else outbound
    ) json.outbounds;
  };
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
    inherit settings;
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
