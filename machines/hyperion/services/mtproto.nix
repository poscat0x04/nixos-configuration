{ config, pkgs, ... }:

{
  sops.secrets.mtproto-config = {};
  networking.firewall.allowedTCPPorts = [ 2285 ];
  systemd.services.mtprotoproxy = {
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      DynamicUser = true;
      User = "mtprotoproxy";
      Group = "mtprotoproxy";
      SystemCallArchitectures = [ "native" ];
      ProtectClock = true;
      ProtectControlGroups = true;
      ProtectHome = true;
      ProtectHostname = true;
      ProtectKernelLogs = true;
      ProtectKernelModules = true;
      ProtectKernelTunables = true;
      ProtectProc = "noaccess";
      RestrictAddressFamilies = [ "AF_INET" "AF_INET6" ];
      RestrictNamespaces = true;
      Restart = "on-failure";
      RestartSec = "2s";
      LoadCredential = "config:${config.sops.secrets.mtproto-config.path}";
      ExecStart = "${pkgs.mtprotoproxy}/bin/mtprotoproxy %d/config";
    };
  };
}
