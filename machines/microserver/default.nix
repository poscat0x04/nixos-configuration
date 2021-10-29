{ lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../profiles/server.nix
    ../../hardware/profiles/uefi.nix
    ../../hardware/cpu/intel
    ../../modules/acme.nix
    ../../modules/avahi.nix
    ../../modules/v2ray
    ../../modules/gnupg-server.nix
    ../../modules/vlmcsd.nix
    ../../modules/nginx.nix
    ../../modules/postgresql.nix
    ./router/dhcp.nix
    ./router/dns.nix
    ./router/firewall.nix
    ./router/networks.nix
    ./router/routing.nix
    ./services/v2ray.nix
    ./services/ddns.nix
    ./services/printing.nix
    ./services/vaultwarden.nix
    ./services/thu-checkin.nix
    ./services/wireguard.nix
    ./services/web
  ];

  nixos.settings = {
    system.user = "poscat";
    machine = {
      hostname = "microserver";
    };
  };

  services.nginx.virtualHosts.default = {
    onlySSL = true;
    listen = [
      {
        addr = "0.0.0.0";
        port = 8443;
        ssl = true;
      }
    ];
    useACMEHost = "poscat.moe-wildcard";
  };

  networking.hostId = "3c7de8b6";

  system.stateVersion = "21.11";
}
