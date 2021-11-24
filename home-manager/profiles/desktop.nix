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
  ];

  manual.html.enable = true;
}
