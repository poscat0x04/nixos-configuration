{ ... }:

{
  imports = [
    ../direnv.nix
    ../haskell.nix
    ../git
    ../gnupg.nix
    ../ssh.nix
  ];

  programs = {
    home-manager.enable = true;

    bat = {
      enable = true;
      config = {
        theme = "OneHalfDark";
      };
    };
  };

  home.stateVersion = "20.09";
}