{ config, ... }:

let
  credentialsFile = config.sops.secrets.acme-secret.path;
  poscat-moe = {
    inherit credentialsFile;
    domain = "poscat.moe";
    dnsProvider = "cloudflare";
  };
  poscat-moe-wildcard = {
    inherit credentialsFile;
    domain = "*.poscat.moe";
    dnsProvider = "cloudflare";
  };
in {
  imports = [ ./sops-nix.nix ];

  sops.secrets.acme-secret = {};

  security.acme = {
    defaults.email = "poscat@poscat.moe";
    acceptTerms = true;
    certs = {
      "poscat.moe" = poscat-moe;
      "poscat.moe-wildcard" = poscat-moe-wildcard;
      "poscat.moe-rsa" = poscat-moe // { keyType = "rsa4096"; };
      "poscat.moe-wildcard-rsa" = poscat-moe-wildcard // { keyType = "rsa4096"; };
    };
  };
}
