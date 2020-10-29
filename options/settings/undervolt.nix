{ lib, ... }:

with lib;

{
  options = {
    nixos.settings.machine.undervolt = {
      core = mkOption {
        type = types.int;
        default = 0;
      };

      gpu = mkOption {
        type = types.int;
        default = 0;
      };

      uncore = mkOption {
        type = types.nullOr types.int;
        default = null;
      };

      analogio = mkOption {
        type = types.nullOr types.int;
        default = null;
      };
    };
  };
}
