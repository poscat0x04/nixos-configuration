{ pkgs, secrets, ... }:

let
  credentialsFile = pkgs.writeText "lego-credentials" ''
    CLOUDFLARE_DNS_API_TOKEN=${secrets.ddns-cloudflare-token}
  '';
in {
  security.acme = {
    email = "poscat@mail.poscat.moe";
    acceptTerms = true;
    certs."poscat.moe" = {
      inherit credentialsFile;
      domain = "*.poscat.moe";
      dnsProvider = "cloudflare";
    };
  };
}
