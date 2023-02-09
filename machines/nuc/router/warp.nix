{ config, ... }:

{
  systemd.network = {
    netdevs."wg0" = {
      netdevConfig = {
        Name = "wg-warp0";
        Kind = "wireguard";
      };

      wireguardConfig = {
        PrivateKeyFile = config.sops.secrets.wg-private-key.path;
        FirewallMark = 1000;
      };
      wireguardPeers = [
        {
          wireguardPeerConfig = {
            PublicKey = "bmXOC+F1FxEMF9dyiK2H5/1SUtzH0JuVo51h2wPfgyo=";
            AllowedIPs = [ "0.0.0.0/0" "::/0" ];
            Endpoint = "162.159.192.20:2408";
            PersistentKeepalive = 20;
          };
        }
      ];
    };

    networks."90-wg0" = {
      matchConfig.Name = "wg-warp0";
      linkConfig = {
        RequiredForOnline = false;
      };
      address = [
        "172.16.0.2/32"
        "2606:4700:110:857c:de77:ab8d:f751:28f8/128"
      ];
      routes = [
        {
          routeConfig = {
            Destination = "0.0.0.0/0";
            Table = "warp";
          };
        }
        {
          routeConfig = {
            Destination = "::/0";
            Table = "warp";
          };
        }
      ];
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
            FirewallMark = 1000;
          };
        }
      ];
    };
  };

  systemd.services.systemd-networkd.serviceConfig.SupplementaryGroups = [ config.users.groups.keys.name ];

  sops.secrets.wg-private-key.owner = "systemd-network";
}
