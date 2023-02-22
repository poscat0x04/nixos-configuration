{ config, networklib, ... }:

{
  networking.firewall.allowedUDPPorts = [ 48927 ];
  systemd.network = with networklib.wireguard; with machines; {
    netdevs."wg0" = {
      netdevConfig = {
        Name = "wg0";
        Kind = "wireguard";
      };
      wireguardConfig = {
        ListenPort = "48927";
        PrivateKeyFile = config.sops.secrets.wg-private-key.path;
        RouteTable = "main";
      };
      wireguardPeers = makeWgPeers [ nuc bwh mba ];
    };
    networks."90-wg0" = {
      matchConfig.Name = "wg0";
      address = [ "${subnetPrefix}.${toString titan.id}/32" ];
    };
  };
}
