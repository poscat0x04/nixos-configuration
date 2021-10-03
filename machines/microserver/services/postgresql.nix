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
    settings = {
      ssl = true;
      ssl_cert_file = "/var/lib/acme/poscat.moe/fullchain.pem";
      ssl_key_file = "/var/lib/acme/poscat.moe/key.pem";
      log_statement = "all";
      log_disconnections = "true";
    };
  };
  users.users.postgres.extraGroups = [ "acme" ];
}
