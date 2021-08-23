{ lib, ... }:

{
  imports = [
    ../../profiles/server.nix
    ../../hardware/profiles/uefi.nix
    ../../hardware/cpu/intel
    ../../modules/v2ray
    ../../modules/smartdns.nix
    ../../modules/gnupg-server.nix
    ./router/dhcp.nix
    ./router/firewall.nix
    ./router/networks.nix
    ./router/routing.nix
    ./hardware-configuration.nix
  ];

  nixos.settings = {
    system.user = "poscat";
    machine = {
      hostname = "microserver";
    };
  };

  networking.hostId = "3c7de8b6";

  system.stateVersion = "21.11";
}
