{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    (agda.withPackages (p: [
        p.standard-library
        p.cubical
    ]))
  ];
}
