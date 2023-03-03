{ nixosModules, ... }:

{
  imports = [ nixosModules.vlmcsd ];

  services.vlmcsd.enable = true;

  networking.firewall.allowedTCPPorts = [ 1688 ];
}
