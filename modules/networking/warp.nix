{ lib, config, networklib, ... }:

let
  cfg = config.networking.warp;
in {
  imports = [
    ../sops-nix.nix
    ./firewall.nix
  ];

  options.networking.warp = with lib; {
    enable = mkOption {
      type = types.bool;
      default = false;
    };

    server = mkOption {
      type = types.str;
      default = "[2606:4700:100::a29f:c102]";
    };

    port = mkOption {
      type = types.port;
      default = 2408;
    };

    manualActivation = mkOption {
      type = types.bool;
      default = false;
    };

    v4addr = mkOption {
      type = types.str;
      default = "172.16.0.2";
    };

    v6addr = mkOption {
      type = types.str;
    };
  };

  config = {
    systemd.network = lib.mkIf cfg.enable {
      netdevs."wg-warp0" = {
        netdevConfig = {
          Name = "wg-warp0";
          Kind = "wireguard";
        };
        wireguardConfig = {
          PrivateKeyFile = config.sops.secrets.wg-private-key.path;
          FirewallMark = networklib.wireguard.fwmark;
        };
        wireguardPeers = [
          {
            wireguardPeerConfig = {
              PublicKey = "bmXOC+F1FxEMF9dyiK2H5/1SUtzH0JuVo51h2wPfgyo=";
              AllowedIPs = [ "0.0.0.0/0" "::/0" ];
              Endpoint = "${cfg.server}:${builtins.toString cfg.port}";
              RouteTable = "warp";
            };
          }
        ];
      };

      networks."95-wg-warp0" = {
        matchConfig = {
          Name = "wg-warp0";
          Type = "wireguard";
        };
        linkConfig = {
          RequiredForOnline = false;
          ActivationPolicy = lib.mkIf cfg.manualActivation "manual";
        };
        address = [ "${cfg.v4addr}/32" "${cfg.v6addr}/128" ];
        routingPolicyRules = [
          {
            routingPolicyRuleConfig = {
              Family = "both";
              Priority = 100;
              Table = "main";
              SuppressPrefixLength = 0;
            };
          }
          {
            routingPolicyRuleConfig = {
              Family = "both";
              Priority = 101;
              Table = "cn";
            };
          }
          {
            routingPolicyRuleConfig = {
              Family = "both";
              Priority = 102;
              Table = "others-direct";
            };
          }
          {
            routingPolicyRuleConfig = {
              Family = "both";
              Priority = 103;
              Table = "warp";
              InvertRule = true;
              FirewallMark = networklib.wireguard.fwmark;
            };
          }
        ];
      };
    };

    # Setup SNAT
    networking.fwng.nftables-service = lib.mkIf cfg.enable {
      wg-warp0-rules = {
        description = "Set up nftables rules (forwarding, filtering) when wg-warp0 is created";
        deviceMode = {
          enable = true;
          interface = "wg-warp0";
          offload = true;
          nat.snatTarget = cfg.v4addr;
          nat66.snatTarget = cfg.v6addr;
        };
      };
    };

    # Allow systemd-networkd to read wireguard private key
    systemd.services.systemd-networkd.serviceConfig.SupplementaryGroups = [ config.users.groups.keys.name ];
    sops.secrets.wg-private-key.owner = "systemd-network";
  };
}
