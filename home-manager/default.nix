{ config, pkgs, ... }:

{
  manual.html.enable = true;

  imports = [
    ./alacritty.nix
    ./firefox
    ./git.nix
    ./mpv.nix
  ];

  xresources.properties = {
    "Xft.dpi" = 240;
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
