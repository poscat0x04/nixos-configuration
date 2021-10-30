{ constants, ... }:

let
  inherit (constants) wg-ipv4-prefix wg-ipv6-prefix;
in {
  systemd.network = {
    netdevs."wg0" = {
      netdevConfig = {
        Name = "wg0";
        Kind = "wireguard";
      };
      wireguardConfig = {
        ListenPort = "48927";
        PrivateKeyFile = "/var/lib/wireguard/wg0.key";
      };
      wireguardPeers = [
        {
          wireguardPeerConfig = {
            PublicKey = constants.wg-public-keys.microserver;
            AllowedIPs = [ "${wg-ipv4-prefix}1/32" "${wg-ipv6-prefix}1/128" ];
            Endpoint = "home.poscat.moe:48927";
          };
        }
      ];
    };
    networks."90-wg0" = {
      matchConfig.Name = "wg0";
      address = [ "${wg-ipv4-prefix}3/24" "${wg-ipv6-prefix}3/64" ];
    };
  };
}
