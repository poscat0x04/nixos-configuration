{ lib, networklib, config, ... }:

let
  json = builtins.fromJSON (builtins.readFile ./settings.json);
  settings = json // { outbounds = map (outbound:
      if outbound.type == "wireguard"&& config.services.sing-box.reserved != null
      then outbound // { inherit (config.services.sing-box) reserved; }
      else outbound
    ) json.outbounds;
  };
in {
  options.services.sing-box.reserved = with lib; mkOption {
    type = types.nullOr (types.listOf types.ints.u8);
    default = null;
  };
  config = {
    sops.secrets = {
      "sing-box/addr" = {};
      "sing-box/sn" = {};
      "sing-box/id" = {};
      "sing-box/shortId" = {};
      "sing-box/publicKey" = {};
      "sing-box/wgPrivateKey" = {};
      "sing-box/v6addr" = {};
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
            Priority = 107;
            Table = "main";
            IPProtocol = "icmp";
          };
        }
        {
          routingPolicyRuleConfig = {
            Family = "both";
            Priority = 107;
            Table = "main";
            IPProtocol = "icmpv6";
          };
        }
        {
          routingPolicyRuleConfig = {
            Family = "both";
            Priority = 109;
            Table = "sing-box";
            InvertRule = true;
            FirewallMark = networklib.wireguard.fwmark;
          };
        }
      ];
    };

    networking.fwng.nftables-service = {
      tun0-rules = {
        description = "trust tun0";
        deviceMode = {
          enable = true;
          interface = "tun0";
          offload = true;
          trust = true;
        };
      };
    };

    systemd.services.sing-box.serviceConfig.Slice = "system-noproxy.slice";
  };
}
