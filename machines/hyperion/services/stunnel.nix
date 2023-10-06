{ config, pkgs, ... }:

let
  cfgFile = pkgs.writeText "stunnel.conf" ''
    debug = err
    foreground = yes
    syslog = no

    sslVersionMin = TLSv1.3

    [smb]
    client = no
    accept = 0.0.0.0:4875
    connect = 127.0.0.1:445
    cert = /run/credentials/stunnel.service/cert.pem
    key = /run/credentials/stunnel.service/key.pem
    ciphers = PSK
    PSKsecrets = /run/credentials/stunnel.service/psk
  '';
in {
  sops.secrets.stunnel-psk = {};

  networking.firewall.allowedTCPPorts = [ 4875 ];
  systemd.services.stunnel = {
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      LoadCredential = [
        "cert.pem:/var/lib/acme/poscat.moe-wildcard/cert.pem"
        "key.pem:/var/lib/acme/poscat.moe-wildcard/key.pem"
        "psk:${config.sops.secrets.stunnel-psk.path}"
      ];
      Type = "simple";
      DynamicUser = true;
      User = "stunnel";
      Group = "stunnel";
      ExecStart = "${pkgs.stunnel}/bin/stunnel ${cfgFile}";
    };
  };
}
