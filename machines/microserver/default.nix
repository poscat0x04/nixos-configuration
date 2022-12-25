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
    ../../modules/vlmcsd.nix
    ../../modules/nginx.nix
    ../../modules/postgresql.nix
    ../../modules/vscode-server.nix
    ./router/dhcp.nix
    ./router/dns.nix
    ./router/firewall.nix
    ./router/networks.nix
    ./router/routing.nix
    ./services/ddns.nix
    ./services/containers.nix
    ./services/printing.nix
    ./services/vaultwarden.nix
    ./services/wireguard.nix
    ./services/samba.nix
    ./services/genshin-checkin.nix
    ./services/transmission.nix
    ./services/znc.nix
    ./services/users.nix
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
