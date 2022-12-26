{ lib, ... }:

{
  imports = [
    ../git
    ../ssh.nix
  ];

  home.packages = lib.mkForce [];

  programs = {
    home-manager.enable = true;

    bat = {
      enable = true;
      config = {
        theme = "OneHalfDark";
      };
    };
  };

  home.stateVersion = "21.11";
}
