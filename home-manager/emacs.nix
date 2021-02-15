{ lib, pkgs, ... }:

with lib; with builtins;

let
  files = attrNames (readDir ./emacs);
  config = map (filename: nameValuePair ("emacs/" + filename) { source = ./emacs + ("/" + filename); }) files;
in

{
  xdg.configFile = listToAttrs config;

  services.emacs = {
    enable = false;
    package = pkgs.customized-emacs;
  };
}
