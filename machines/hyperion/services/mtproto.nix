{ config, pkgs, ... }:

let
  mtg = builtins.fetchTarball {
    url = "https://github.com/9seconds/mtg/releases/download/v2.1.7/mtg-2.1.7-linux-amd64.tar.gz";
    sha256 = "1gmrygkgf89q47bv9vzqkagkzn0xfvav714xjdmyvf9q3y1qmwza";
  };
in {
  sops.secrets.mtg-config = {};
  networking.firewall.allowedTCPPorts = [ 2285 ];
  systemd.services.mtg = {
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      DynamicUser = true;
      User = "mtg";
      Group = "mtg";
      CapabilityBoundingSet = "";
      LockPersonality = true;
      NoNewPrivileges = true;
      PrivateDevices = true;
      PrivateTmp = true;
      ProtectClock = true;
      ProtectControlGroups = true;
      ProtectHome = true;
      ProtectHostname = true;
      ProtectKernelLogs = true;
      ProtectKernelModules = true;
      ProtectKernelTunables = true;
      ProtectProc = "invisible";
      ProtectSystem = "strict";
      RestrictAddressFamilies = [ "AF_INET" "AF_INET6" ];
      SystemCallArchitectures = [ "native" ];
      SystemCallFilter = [ "~@privileged" ];
      RestrictNamespaces = true;
      Restart = "on-failure";
      RestartSec = "2s";
      LoadCredential = "config:${config.sops.secrets.mtg-config.path}";
      ExecStart = "${mtg}/mtg run %d/config";
    };
  };
}
