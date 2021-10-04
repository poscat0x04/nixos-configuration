{ lib, pkgs, ... }:

{
  manual.html.enable = true;

  imports = [
    ./alacritty.nix
    ./direnv.nix
    ./emacs.nix
    ./firefox
    ./haskell.nix
    ./git
    ./gnupg.nix
    ./konsole.nix
    ./mpv.nix
  ];

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
          forwardX11 = true;
          forwardX11Trusted = true;
          remoteForwards = [
            {
              bind.address = "/run/user/1000/gnupg/S.gpg-agent";
              host.address = "/run/user/1000/gnupg/S.gpg-agent";
            }
            {
              bind.address = "/run/user/1000/gnupg/S.gpg-agent.ssh";
              host.address = "/run/user/1000/gnupg/S.gpg-agent.ssh";
            }
          ];
        };
        rpi = {
          hostname = "192.168.1.187";
        };
        microserver = {
          hostname = "10.1.10.1";
          forwardX11 = true;
          forwardX11Trusted = true;
          remoteForwards = [
            {
              bind.address = "/run/user/1000/gnupg/S.gpg-agent";
              host.address = "/run/user/1000/gnupg/S.gpg-agent";
            }
            {
              bind.address = "/run/user/1000/gnupg/S.gpg-agent.ssh";
              host.address = "/run/user/1000/gnupg/S.gpg-agent.ssh";
            }
          ];
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
