{ nixosModules, ... }:

{
  imports = [ nixosModules.nixos-firewall-ng ];

  networking = {
    firewall.rejectPackets = true;
    fwng.enable = true;
  };
}
