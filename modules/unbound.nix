{ pkgs, ... }:

{
  services.unbound = {
    enable = true;
    settings = {
      server = {
        verbosity = 1;

        num-threads = 1;

        msg-cache-slabs = 2;
        rrset-cache-slabs = 2;
        infra-cache-slabs = 2;
        key-cache-slabs = 2;

        msg-cache-size = "8m";
        rrset-cache-size = "16m";

        outgoing-port-permit = "10240-65535";
        outgoing-range = 8192;
        num-queries-per-thread = 4096;

        prefetch = true;
        prefetch-key = true;

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
      forward-zone = import pkgs.unbound-china-domain-list ++ [
        {
          name = ".";
          forward-addr = "101.6.6.6@8853";
          forward-tls-upstream = true;
        }
      ];
    };
  };
}
