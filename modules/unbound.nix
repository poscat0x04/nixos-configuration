{ pkgs, lib, config, ... }:

{
  options = {
    services.unbound.additionalInterfaces = lib.mkOption {
      type = lib.types.listOf (lib.types.str);
      default = [];
    };
  };
  config = {
    services.unbound = {
      enable = true;
      package = pkgs.unbound-full;
      enableRootTrustAnchor = false;
      settings = {
        server = {
          verbosity = 1;

          num-threads = 2;

          module-config = "\"subnetcache iterator\"";

          interface = [ "127.0.0.1" "::1" ]
            ++ config.services.unbound.additionalInterfaces;

          access-control = [
            "10.0.0.0/8 allow"
            "127.0.0.1/8 allow"
            "::1/128 allow"
          ];

          msg-cache-slabs = 2;
          rrset-cache-slabs = 2;
          infra-cache-slabs = 2;
          key-cache-slabs = 2;

          msg-cache-size = "8m";
          rrset-cache-size = "16m";

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

          local-data = [
            "'cdn.sstatic.net.  60     IN      A       172.64.147.34'"
          ];
        };
        forward-zone = import (pkgs.unbound-china-domain-list.override {servers = ["223.5.5.5" "223.6.6.6"];}) ++ [
          {
            name = ".";
            forward-addr = [
              "101.102.103.104@853"
            ];
            forward-tls-upstream = true;
          }
        ];
      };
    };
  };
}
