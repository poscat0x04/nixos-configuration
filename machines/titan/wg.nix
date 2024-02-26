{ config, networklib, ... }:

with networklib.wireguard;

{
  networking.firewall.allowedUDPPorts = [ port ];
  systemd.network = with machines; {
    netdevs."wg0" = {
      netdevConfig = {
        Name = "wg0";
        Kind = "wireguard";
      };
      wireguardConfig = {
        ListenPort = port;
        PrivateKeyFile = config.sops.secrets.wg-private-key.path;
        RouteTable = "main";
        FirewallMark = fwmark;
      };
      wireguardPeers = makeWgPeers [ bwh mba ] ++ [ (makeWgPeer' [ "10.1.20.0/24" ] nuc) ] ;
    };
    networks."90-wg0" = {
      matchConfig.Name = "wg0";
      address = [ "${subnetPrefix}.${toString titan.id}/32" ];
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
