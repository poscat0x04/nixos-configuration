{ pkgs, secrets, ... }:

let
  credentialsFile = pkgs.writeText "lego-credentials" ''
    CLOUDFLARE_DNS_API_TOKEN=${secrets.ddns-cloudflare-token}
  '';
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
  security.acme = {
    email = "poscat@mail.poscat.moe";
    acceptTerms = true;
    certs = {
      "poscat.moe" = poscat-moe;
      "poscat.moe-wildcard" = poscat-moe-wildcard;
      "poscat.moe-rsa" = poscat-moe // { keyType = "rsa4096"; };
      "poscat.moe-wildcard-rsa" = poscat-moe-wildcard // { keyType = "rsa4096"; };
    };
  };
}
