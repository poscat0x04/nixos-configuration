{ lib, ... }:

with lib;

{
  options = {
    programs.chromium.cliArgs = mkOption {
      type = types.listOf types.str;
      description = ''
        Chromium command line arguments
      '';
      default = [];
    };
  };
}
