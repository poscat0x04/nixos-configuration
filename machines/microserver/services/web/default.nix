{ config, ... }:

let
  cfg = config.nixos.settings;
in {
  users = {
    users."${cfg.system.user}".extraGroups = [ "http" ];
    groups = {
      http = {};
    };
  };
}
