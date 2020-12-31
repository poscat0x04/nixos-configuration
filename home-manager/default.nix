{ sysConfig, lib, pkgs, ... }:

let
  dpi = sysConfig.nixos.settings.machine.dpi;
in
  {
    manual.html.enable = true;

    imports = [
      ./alacritty.nix
      ./direnv.nix
      ./emacs.nix
      ./firefox
      ./haskell.nix
      ./git.nix
      ./konsole.nix
      ./mpv.nix
    ];

    xresources.properties = {
      "Xft.dpi" = lib.mkIf (dpi != null) dpi;
    };

    programs = {
      home-manager.enable = true;

      ssh = {
        enable = true;
        matchBlocks = {
          bwh = {
            hostname = "64.64.228.47";
          };
          archcn = {
            hostname = "build.archlinuxcn.org";
            serverAliveInterval = 30;
          };
          router = {
            hostname = "home.poscat.moe";
            user = "root";
          };
          rpi = {
            hostname = "192.168.1.187";
          };
        };
      };

      bat = {
        enable = true;
        config = {
          theme = "OneHalfDark";
        };
      };
    };

    home.stateVersion = "20.09";
  }
