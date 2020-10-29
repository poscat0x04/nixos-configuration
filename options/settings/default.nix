{ secrets, pkgs, config, lib, ... }:

with lib;
let
  cfg = config.nixos.settings;
in
{
  imports = [
    ./machine.nix
  ];

  options.nixos.settings = {
    system = {
      user = mkOption {
        type = types.str;
        readOnly = true;
        description = ''
          The username of the user account
        '';
      };

      home = mkOption {
        type = types.path;
        visible = false;
        readOnly = true;
        default = "/home/${cfg.system.user}";
        description = ''
          Home directory of the user
        '';
      };

      password = mkOption {
        type = types.str;
        visible = false;
        default = secrets.passwords.users cfg.system.user;
        description = ''
          The user account's password file
        '';
      };
    };
  };

  config = {
  };
}
