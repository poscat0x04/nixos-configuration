{ pkgs, lib, config, ... }:

{
  config = {
    services.unbound = {
      enable = true;
      package = pkgs.unbound-full;
      settings = {
        server = {
          verbosity = 0;

          num-threads = 1;

          module-config = "\"subnetcache validator iterator\"";

          do-tcp = false;

          interface = [ "127.0.0.1" ];

          outgoing-port-permit = "10240-65535";
          outgoing-range = 8192;
          num-queries-per-thread = 4096;

          tls-ciphersuites = "TLS_AES_256_GCM_SHA384:TLS_AES_128_GCM_SHA256";

          prefetch = true;

          fast-server-permil = 1000;
          fast-server-num = 1;

          cache-min-ttl = "60";
          cache-max-ttl = "86400";

          val-permissive-mode = true;
          val-log-level = 1;

          client-subnet-zone = ".";
          client-subnet-always-forward = true;

          hide-identity = true;
          hide-version = true;

          private-address = [
            "10.0.0.0/8"
            "100.64.0.0/10"
            "169.254.0.0/16"
            "172.16.0.0/12"
            "192.168.0.0/16"
            "fc00::/7"
            "fe80::/10"
          ];
        };
        forward-zone = [
          {
            name = ".";
            forward-addr = [
              "8.8.8.8"
              "8.8.4.4"
              "9.9.9.9"
            ];
          }
        ];
      };
    };
  };
}
