{ nixosModules, ... }:

{
  imports = [
    nixosModules.vlmcsd
  ];

  services.vlmcsd.enable = true;

  systemd.services.vlmcsd.serviceConfig.Slice = "system-noproxy.slice";
}
