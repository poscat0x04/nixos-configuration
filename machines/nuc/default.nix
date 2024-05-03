{ lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../profiles/server.nix
    ../../hardware/profiles/uefi.nix
    ../../hardware/cpu/intel
    ../../modules/networking/warp.nix
    ../../modules/promethus/node.nix
    ../../modules/promethus/ping.nix
    ../../modules/sing-box
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

  system.stateVersion = "22.11";
}
