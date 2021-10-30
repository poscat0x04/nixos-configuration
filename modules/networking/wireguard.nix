{ constants, pkgs, secrets, ... }:

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
        PrivateKeyFile = "/var/lib/wireguard/wg0.key";
        ListenPort = "48927";
        FirewallMark = 200;
      };
      wireguardPeers = [
        {
          wireguardPeerConfig = {
            PublicKey = constants.wg-public-keys.microserver;
            AllowedIPs = [ "0.0.0.0/0" "::/0" ];
            Endpoint = "home.poscat.moe:48927";
          };
        }
        {
          wireguardPeerConfig = {
            PublicKey = constants.wg-public-keys.microserver;
            AllowedIPs = [ "${wg-ipv4-prefix}3" "${wg-ipv6-prefix}3" ];
            Endpoint = "${secrets.v2ray-server.address}:48927";
          };
        }
      ];
    };
    networks."90-wg0" = {
      matchConfig.Name = "wg0";
      address = [ "${wg-ipv4-prefix}2/24" "${wg-ipv6-prefix}2/64" ];
      routes = [
        {
          routeConfig = {
            Destination = "10.1.10.0/24";
            Scope = "link";
          };
        }
      ];
    };
  };
  networking.nftables.extraInputRules = ''
    iif wg0 accept comment "Allow input from wireguard"
  '';
}
