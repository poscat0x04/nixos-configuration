{ lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../profiles/server.nix
    ../../modules/gnupg-server.nix
    ../../modules/acme.nix
    ../../modules/nginx.nix
  ];

  boot = {
    loader.grub = {
      enable = true;
      device = "/dev/sda";
    };
    zfs.enableUnstable = false;
  };

  nixos.settings = {
    system.user = "poscat";
    machine = {
      hostname = "bwh";
    };
  };

  services = {
    zfs.autoScrub.enable = false;
    btrfs.autoScrub.enable = true;
  };

  nix.useMirror = false;

  networking.timeServers = lib.mkForce [
    "time.nist.gov"
    "time.cloudflare.com"
  ];

  networking.firewall.enable = false;

  networking.hostId = "bd66af60";

  system.stateVersion = "21.11";
}
