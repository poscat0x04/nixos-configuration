{ lib, pkgs, ... }:

let
  ot-port = 29384;
  cfgFile = pkgs.writeText "opentracker-cfg" ''
    listen.tcp 127.0.0.1:${toString ot-port}
    access.proxy 127.0.0.1
    tracker.redirect_url https://www.cloudflare.com/
  '';
  cfgFileV6 = pkgs.writeText "opentracker-cfg" ''
    listen.tcp [::1]:${toString ot-port}
    access.proxy ::1
    tracker.redirect_url https://www.cloudflare.com/
  '';
  ot = pkgs.opentracker.overrideAttrs (old: {
    makeFlags = old.makeFlags ++ [
      "-E FEATURES+=-DWANT_IP_FROM_PROXY"
      "-E CFLAGS+=-march=native"
      "-E CFLAGS+=-flto"
    ];
  });
  ot-ipv6 = ot.overrideAttrs (old: {
    makeFlags = old.makeFlags ++ [ "-E FEATURES+=-DWANT_V6" ];
  });
  gen-service = pkg: cfg: {
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "simple";
      Restart = "always";
      DynamicUser = true;
      User = "opentracker";
      Group = "opentracker";
      ExecStart = "${lib.getBin pkg}/bin/opentracker -f ${cfg}";
      CapabilityBoundingSet = "";
      LockPersonality = true;
      NoNewPrivileges = true;
      PrivateDevices = true;
      PrivateTmp = true;
      ProtectHome = true;
      ProtectClock = true;
      ProtectControlGroups = true;
      ProtectHostname = true;
      ProtectKernelLogs = true;
      ProtectKernelModules = true;
      ProtectKernelTunables = true;
      ProtectProc = "invisible";
      ProtectSystem = "strict";
      RestrictAddressFamilies = [ "AF_INET" "AF_INET6" ];
      RestrictNamespaces = true;
      RestrictRealtime = true;
      RestrictSUIDSGID = true;
      SystemCallArchitectures = "native";
      SystemCallFilter = [ "~@privileged" ];
    };
  };
in {
  systemd.services = {
    opentracker = gen-service ot cfgFile;
    opentracker-v6 = gen-service ot-ipv6 cfgFileV6;
  };
  services.nginx = {
    virtualHosts."tr.poscat.moe" = {
      onlySSL = true;
      useACMEHost = "poscat.moe-wildcard";
      kTLS = true;
      listen = [
        {
          addr = "0.0.0.0";
          port = 8443;
          ssl = true;
        }
        {
          addr = "[::0]";
          port = 8443;
          ssl = true;
        }
      ];
      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString ot-port}";
        recommendedProxySettings = true;
      };
      locations."/v6/" = {
        proxyPass = "http://[::1]:${toString ot-port}/";
        recommendedProxySettings = true;
      };
      extraConfig = ''
        set_real_ip_from 173.245.48.0/20;
        set_real_ip_from 103.21.244.0/22;
        set_real_ip_from 103.22.200.0/22;
        set_real_ip_from 103.31.4.0/22;
        set_real_ip_from 141.101.64.0/18;
        set_real_ip_from 108.162.192.0/18;
        set_real_ip_from 190.93.240.0/20;
        set_real_ip_from 188.114.96.0/20;
        set_real_ip_from 197.234.240.0/22;
        set_real_ip_from 198.41.128.0/17;
        set_real_ip_from 162.158.0.0/15;
        set_real_ip_from 104.16.0.0/13;
        set_real_ip_from 104.24.0.0/14;
        set_real_ip_from 172.64.0.0/13;
        set_real_ip_from 131.0.72.0/22;
        set_real_ip_from 2400:cb00::/32;
        set_real_ip_from 2606:4700::/32;
        set_real_ip_from 2803:f800::/32;
        set_real_ip_from 2405:b500::/32;
        set_real_ip_from 2405:8100::/32;
        set_real_ip_from 2a06:98c0::/29;
        set_real_ip_from 2c0f:f248::/32;
        real_ip_header CF-Connecting-IP;

        error_page 497 301 =307 https://$host$request_uri;
        add_header Strict-Transport-Security 'max-age=31536000' always;
      '';
    };
  };
}
