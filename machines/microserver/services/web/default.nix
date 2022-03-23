{ config, ... }:

let
  cfg = config.nixos.settings;
in {
  imports = [
    ./webdav.nix
  ];
}
