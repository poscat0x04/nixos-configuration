{ ... }:
{
  imports = [ ../../../modules/networking/firewall.nix ];

  networking = {
    firewall = {
      trustedInterfaces = [ "ens36" "ens37" ];
      logRefusedConnections = false;
    };
    fwng = {
      flowtable.devices = [ "ens36" "ens37" ];
      nat.enable = true;
      nat66.enable = true;
      nftables-service = {
        ppp0-rules = {
          description = "Set up nftables rules (forwarding, filtering) when ppp0 is created";
          deviceMode = {
            enable = true;
            interface = "ppp0";
            offload = true;
            nat.masquerade = true;
          };
        };
        wg-warp0-rules = {
          description = "Set up nftables rules (forwarding, filtering) when wg-warp0 is created";
          deviceMode = {
            enable = true;
            interface = "wg-warp0";
            offload = true;
            nat.snatTarget = "172.16.0.2";
            nat66.snatTarget = "2606:4700:110:88a9:c600:230:a4c0:54c8";
          };
        };
      };
    };
  };
}
