{ ... }:

{
  imports = [
    ../alacritty.nix
    ../emacs.nix
    ../firefox
    ../konsole.nix
    ../mpv.nix
    ../grip.nix
    ../code
    ../neovim-qt.nix
  ];

  manual.html.enable = true;
}
