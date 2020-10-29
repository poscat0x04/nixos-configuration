{ lib, ... }:

with lib;
{
  options.nixos.settings.machine = {
    hostname = mkOption {
      type = types.str;
      default = "nixos";
      description = ''
        The desired hostname of the machine
      '';
    };

    screen = {
      width = mkOption {
        type = types.int;
        default = 3840;
        description = ''
          Screen width
        '';
      };

      height = mkOption {
        type = types.int;
        default = 2160;
        description = ''
          Screen height
        '';
      };
    };
  };
}
