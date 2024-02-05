{ ... }:

{
  services.squid = {
    enable = true;
    proxyPort = 8080;
    proxyAddress = "10.1.100.4";
  };

  nixpkgs.config.permittedInsecurePackages = [ "squid-5.9" ];
}
