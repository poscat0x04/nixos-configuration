{ ... }:

{
  imports = [
    ../alacritty.nix
    ../emacs.nix
    ../firefox
    ../konsole.nix
    ../mpv.nix
    ../grip.nix
    ../direnv.nix
    ../haskell.nix
    ../code
    ../neovim-qt.nix
    ../zathura.nix
    ../latex.nix
  ];

  manual.html.enable = true;
}
