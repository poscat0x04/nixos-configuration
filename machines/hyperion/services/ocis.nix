{ config, pkgs, ... }:

let
  cfg = name: content: pkgs.writeTextDir "${name}.yaml" content;
  ocis-bin = pkgs.fetchurl {
    name = "ocis";
    url = "https://download.owncloud.com/ocis/ocis/stable/5.0.0/ocis-5.0.0-linux-amd64";
    # use nix-prefetch-url --executable to get the hash
    sha256 = "1w6fwkcqdvib265zcdsx9x2zf0h2nn66cjrwgfszy995ml0qhql2";
    executable = true;
  };

  ocis-test-bin = pkgs.fetchurl {
    name = "ocis";
    url = "https://download.owncloud.com/ocis/ocis/testing/5.0.0-rc.4/ocis-5.0.0-rc.4-linux-amd64";
    sha256 = "0xk5lvspkb012z8xn6jl5czc37pnrxdrxfr2s88vc8803jryr8b4";
    executable = true;
  };

  services = [
    "app-provider"
    "app-registry"
    "auth-basic"
    "auth-bearer"
    "auth-machine"
    "auth-service"
    "eventhistory"
    "frontend"
    "gateway"
    "graph"
    "groups"
    "idm"
    "idp"
    "invitations"
    "nats"
    "notifications"
    "ocdav"
    "ocs"
    "postprocessing"
    "proxy"
    "search"
    "settings"
    "sharing"
    "sse"
    "storage-publiclink"
    "storage-shares"
    "storage-system"
    "storage-users"
    "store"
    "thumbnails"
    "userlog"
    "users"
    "web"
    "webdav"
    "webfinger"
  ];
  serviceStr = builtins.concatStringsSep "," services;

  ocis = cfg "ocis" ''
    # common
    log:
      level: warn
      color: true
      pretty: true
    cache:
      store: redis
      nodes: unix:///run/redis/redis.sock?db=4&pool_size=100
      ttl: 108000

    # service specific
    graph:
      application:
        id: 96824028-6810-4a03-8b23-da474cce460e
      events:
        tls_insecure: false
      spaces:
        insecure: false
    frontend:
      archiver:
        insecure: false
    auth_bearer:
      auth_providers:
        oidc:
          insecure: false
    ocdav:
      insecure: false
    thumbnails:
      thumbnail:
        webdav_allow_insecure: false
        cs3_allow_insecure: false
    search:
      events:
        tls_insecure: false
    audit:
      events:
        tls_insecure: false
    sharing:
      events:
        tls_insecure: false
    storage_users:
      events:
        tls_insecure: false
      mount_id: d6c47e8e-066a-4c3a-81a8-b0b25b699eff
    nats:
      nats:
        tls_skip_verify_client_cert: false
    gateway:
      storage_registry:
        storage_users_mount_id: d6c47e8e-066a-4c3a-81a8-b0b25b699eff
    idp:
      refresh_token_duration_seconds: 7776000
  '';
  proxy = cfg "proxy" ''
    http:
      addr: 127.0.0.1:9200
      tls: false
    oidc:
      insecure: false
    insecure_backends: false
  '';
  sse = cfg "sse" ''
    http:
      addr: 127.0.0.1:9732
  '';
  notifications = cfg "notifications" ''
    notifications:
      SMTP:
        smtp_host: "smtp.main.me.com"
        smtp_port: 587
        smtp_sender: "owncloud <no-reply@poscat.moe>"
        insecure: false
        smtp_encryption: starttls
      events:
        tls_insecure: false
  '';
  cfgDir = pkgs.symlinkJoin { name = "ocis-cfg"; paths = [ ocis proxy sse notifications ]; };
in {
  sops.secrets.ocis-secret = {};

  services.nginx = {
    virtualHosts."own.poscat.moe" = {
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
        proxyPass = "http://127.0.0.1:9200";
        extraConfig = ''
          proxy_set_header        Host $host:$server_port;
          proxy_set_header        X-Real-IP $remote_addr;
          proxy_set_header        X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header        X-Forwarded-Proto $scheme;
          proxy_set_header        X-Forwarded-Host $host;
          proxy_set_header        X-Forwarded-Server $host;
          client_max_body_size 0;
        '';
      };
      extraConfig = ''
        error_page 497 301 =307 https://$host:$server_port$request_uri;
        add_header Strict-Transport-Security 'max-age=31536000' always;
      '';
    };
  };

  systemd.services.ocis = {
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    serviceConfig = {
      User = "ocis";
      Group = "ocis";
      StateDirectory = "ocis";
      DynamicUser = true;
      PrivateTmp = true;
      PrivateDevices = true;
      LockPersonality = true;
      ProtectHome = true;
      ProtectHostname = true;
      ProtectKernelLogs = true;
      ProtectKernelModules = true;
      ProtectKernelTunables = true;
      ProtectControlGroups = true;
      ProtectProc = "invisible";
      RestrictAddressFamilies = [ "AF_UNIX" "AF_INET" ];
      RestrictNamespaces = true;
      RestrictRealtime = true;
      RestrictSUIDSGID = true;
      CapabilityBoundingSet = [ "" ];
      DeviceAllow = [ "" ];
      SystemCallArchitectures = "native";
      Environment = [
        "OCIS_RUN_SERVICES=${serviceStr}"
        "OCIS_URL=https://own.poscat.moe:8443"
        "OCIS_BASE_DATA_PATH=/var/lib/ocis"
        "OCIS_CONFIG_DIR=${cfgDir}"
        "PROXY_ENABLE_BASIC_AUTH=true"
      ];
      EnvironmentFile = config.sops.secrets.ocis-secret.path;
      Restart = "always";
      ExecStart = "${ocis-bin} server";
      SupplementaryGroups = [ "redis" ];
    };
  };
}
