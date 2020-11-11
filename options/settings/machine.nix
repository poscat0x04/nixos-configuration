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

    dpi = mkOption {
      type = types.nullOr types.int;
      default = null;
      description = ''
        The desired dpi of the machine
      '';
    };
  };
}
