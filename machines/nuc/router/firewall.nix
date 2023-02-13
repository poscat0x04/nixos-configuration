{ ... }:

{
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
      };
    };
  };
}
