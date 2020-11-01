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

    zsh = {
      enable = true;

      enableCompletion = false;
      envExtra = ''
        alias fs="nix-env -f '<nixpkgs>' -qaP -A"
        alias cb="hpack && cabal build --ghc-options='-Wall -fno-warn-unused-do-bind'"
        alias ct="cabal new-test --test-show-details=streaming --disable-documentation"
        alias doc="hpack && cabal haddock"
        alias pb="curl -F 'c=@-' 'https://fars.ee/'"
      '';
    };
  };

  home.stateVersion = "20.09";
}
