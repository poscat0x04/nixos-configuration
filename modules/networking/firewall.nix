{ nixosModules, ... }:

{
  imports = [ nixosModules.nixos-firewall-ng ];

  networking = {
    firewall.rejectPackets = true;
    fwng = {
      enable = true;
      cgroupMarks = {
        "system.slice/system-noproxy.slice" = "1000";
      };
    };
  };
}
