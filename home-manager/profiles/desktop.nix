{ ... }:

{
  imports = [
    ../alacritty.nix
    ../emacs.nix
    ../firefox
    ../konsole.nix
    ../mpv.nix
  ];

  manual.html.enable = true;
}
