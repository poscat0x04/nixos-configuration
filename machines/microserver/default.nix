{ lib, ... }:

{
  imports = [
    ../../profiles/server.nix
    ../../hardware/profiles/uefi.nix
    ../../hardware/cpu/intel
    ../../modules/v2ray
    ../../modules/gnupg-server.nix
    ../../modules/vlmcsd.nix
    ./router/dhcp.nix
    ./router/dns.nix
    ./router/firewall.nix
    ./router/networks.nix
    ./router/routing.nix
    ./services/v2ray.nix
    ./services/ddns.nix
    ./services/acme.nix
    ./services/nginx.nix
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
