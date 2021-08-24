{ nixosModules, ... }:

{
  imports = [
    nixosModules.vlmcsd
  ];

  services.vlmcsd.enable = true;
}
