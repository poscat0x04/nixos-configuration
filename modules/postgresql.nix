{ pkgs, lib, ... }:

{
  services.postgresql = {
    enable = true;
    enableTCPIP = true;
    package = pkgs.postgresql_14;
    ensureDatabases = [];
    authentication = lib.mkForce ''
      hostssl all all 0.0.0.0/0    password
      local   all all              trust
      host    all all 127.0.0.1/32 trust
      host    all all ::1/128      trust
      host    all all 10.1.10.1/24 scram-sha-256
    '';
    initdbArgs = [
      "--locale=en_US.UTF-8"
      "--encoding=UTF8"
    ];
    settings = {
      ssl = true;
      ssl_cert_file = "/run/credentials/postgresql.service/cert.pem";
      ssl_key_file = "/run/credentials/postgresql.service/key.pem";
      log_statement = "all";
      log_disconnections = "true";
    };
  };

  security.acme.certs."poscat.moe-wildcard".reloadServices = [ "postgresql.service" ];
  systemd.services.postgresql = {
    wants = [ "acme-finished-poscat.moe-wildcard.target" ];
    after = [ "acme-finished-poscat.moe-wildcard.target" ];
    serviceConfig.LoadCredential = [
      "cert.pem:/var/lib/acme/poscat.moe-wildcard/cert.pem"
      "key.pem:/var/lib/acme/poscat.moe-wildcard/key.pem"
    ];
  };
}