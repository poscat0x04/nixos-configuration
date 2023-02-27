{ pkgs, lib, ... }:

{
  imports = [ ./acme.nix ];

  networking.firewall.allowedTCPPorts = [ 5432 ];

  services.postgresql = {
    enable = true;
    enableTCPIP = true;
    package = pkgs.postgresql_15;
    checkConfig = false;
    authentication = lib.mkForce ''
      local   all all                  peer
      host    all all    127.0.0.1/32  password
      host    all all    ::1/128       password
      host    all all    10.1.10.1/24  scram-sha-256
      host    all all    10.1.20.1/24  scram-sha-256
      host    all all    10.1.100.1/24 scram-sha-256
      hostssl all all    all           password
    '';
    initdbArgs = [ "--encoding=UTF8" ];
    settings = {
      unix_socket_directories = "/run/postgresql";
      ssl = true;
      ssl_cert_file = "/run/credentials/postgresql.service/cert.pem";
      ssl_key_file = "/run/credentials/postgresql.service/key.pem";
      authentication_timeout = "10";

      # optimizations
      shared_buffers = "4GB";
      max_wal_size = "2GB";
      full_page_writes = false;

      # locale
      datestyle = "iso, ymd";
      timezone = "Asia/Shanghai";
      lc_time = "en_DK.UTF-8";
    };
  };

  security.acme.certs."poscat.moe-wildcard".reloadServices = [ "postgresql.service" ];
  systemd.services.postgresql = {
    requires = [ "acme-finished-poscat.moe-wildcard.target" ];
    after = [ "acme-finished-poscat.moe-wildcard.target" ];
    serviceConfig = {
      LoadCredential = [
        "cert.pem:/var/lib/acme/poscat.moe-wildcard/cert.pem"
        "key.pem:/var/lib/acme/poscat.moe-wildcard/key.pem"
      ];
      Slice = "system-noproxy.slice";
      # Give postgresql enough time for cleanup
      TimeoutSec = lib.mkForce "10min";
    };
  };
}
