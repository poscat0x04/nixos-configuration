{ config, ... }:

let
  cfg = config.nixos.settings;
in {
  users = {
    users."${cfg.system.user}".extraGroups = [ "http" "timemachine" "share" "git" ];
    groups = {
      http = {};
      timemachine = {};
      share = {};
      git = {};
    };
  };
}
