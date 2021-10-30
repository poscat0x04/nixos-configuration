{ constants, secrets, ... }:

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
            PublicKey = constants.wg-public-keys.x1c;
            AllowedIPs = [ "${wg-ipv4-prefix}2/32" "${wg-ipv6-prefix}2/128" ];
          };
        }
        {
          wireguardPeerConfig = {
            PublicKey = constants.wg-public-keys.bwh;
            AllowedIPs = [ "${wg-ipv4-prefix}3/32" "${wg-ipv6-prefix}3/128" ];
            Endpoint = "${secrets.v2ray-server.address}:48927";
          };
        }
      ];
    };
    networks."90-wg0" = {
      matchConfig.Name = "wg0";
      address = [ "${wg-ipv4-prefix}1/24" "${wg-ipv6-prefix}1/64" ];
    };
  };
}
