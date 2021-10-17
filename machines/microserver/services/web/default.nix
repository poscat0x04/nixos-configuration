{ config, ... }:

let
  cfg = config.nixos.settings;
in {
  imports = [
    ./webdav.nix
  ];
  users = {
    users."${cfg.system.user}".extraGroups = [ "http" ];
    groups = {
      http = {};
    };
  };
}
