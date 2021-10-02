{ ... }:

{
  imports = [
    ../../../modules/unbound.nix
  ];
  services.unbound.additionalInterfaces = [ "10.1.10.1" ];
}
