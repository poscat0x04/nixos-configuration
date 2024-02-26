{ nixosModules, networklib, ... }:

{
  imports = [ nixosModules.nixos-firewall-ng ];

  networking = {
    firewall.rejectPackets = true;
    fwng = {
      enable = true;
      cgroupMarks = {
        "system.slice/system-noproxy.slice" = builtins.toString networklib.wireguard.fwmark;
      };
    };
  };
}
