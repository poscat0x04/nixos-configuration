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
        ListenPort = 48927;
        PrivateKeyFile = config.sops.secrets.wg-private-key.path;
        RouteTable = "main";
      };
      wireguardPeers = makeWgPeers [ bwh ] ++ [ (makeWgPeer' [ "10.1.10.0/24" ] titan) ];
    };
    networks."90-wg0" = {
      matchConfig.Name = "wg0";
      address = [ "${subnetPrefix}.${toString nuc.id}/32" ];
    };
  };

  networking.fwng.nftables-service = {
    wg0-rules = {
      description = "Set up nftables rules (forwarding, filtering) when wg0 is created";
      deviceMode = {
        enable = true;
        interface = "wg0";
        offload = true;
        trust = true;
      };
    };
  };
}
