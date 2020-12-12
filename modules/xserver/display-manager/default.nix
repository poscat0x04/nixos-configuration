{ config, lib, ... }:

let
  dpi = config.nixos.settings.machine.dpi;
  user = config.nixos.settings.system.user;
in
  {
    services.xserver.displayManager = {
      sddm = {
        enable = true;
        extraConfig = lib.mkIf (dpi != null) ''
          [X11]
          ServerArguments=-nolisten tcp -dpi ${builtins.toString dpi}
        '';
      };
      defaultSession = lib.mkDefault "plasma5";
      autoLogin = {
        enable = true;
        inherit user;
      };
    };
  }
