{ lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../profiles/server.nix
    ../../hardware/profiles/uefi.nix
    ../../hardware/cpu/intel
    ../../modules/networking/warp.nix
    ../../modules/journal-upload.nix
    ./router/dns.nix
    ./router/firewall.nix
    ./router/networks.nix
  ];

  nixos.settings = {
    system.user = "poscat";
    machine.hostname = "nuc";
  };

  virtualisation.vmware.guest = {
    enable = true;
    headless = true;
  };

  services.timesyncd.enable = false;

  systemd.services.systemd-journal-upload = {
    wantedBy = lib.mkForce [ "sys-subsystem-net-devices-ppp0.device" ];
    requires = [ "sys-subsystem-net-devices-ppp0.device" "network-online.target" ];
    after = [ "sys-subsystem-net-devices-ppp0.device" "network-online.target" ];
  };

  system.stateVersion = "22.11";
}
