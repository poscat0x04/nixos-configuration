{ lib, pkgs, ... }:

with lib; with builtins;

let
  files = attrNames (readDir ./emacs-new);
  config = map (filename: nameValuePair ("emacs/" + filename) { source = ./emacs-new + ("/" + filename); }) files;
in

{
  xdg.configFile = listToAttrs config;

  services.emacs = {
    enable = true;
    package = pkgs.customized-emacs;
  };
}
