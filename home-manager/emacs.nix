{ lib, ... }:

with lib; with builtins;

let
  files = attrNames (readDir ./emacs);
  config = map (filename: nameValuePair ("emacs/" + filename) { source = ./emacs + ("/" + filename); }) files;
in

{
  xdg.configFile = listToAttrs config;
}
