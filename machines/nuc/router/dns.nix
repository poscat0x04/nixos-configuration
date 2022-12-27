{ ... }:

{
  imports = [
    ../../../modules/unbound.nix
  ];
  services.unbound.additionalInterfaces = [ "10.1.20.1" ];
}
