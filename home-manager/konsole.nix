{ pkgs, ... }:

{
  xdg.dataFile."konsole/nord.colorscheme".source = "${pkgs.extra-files.nord-konsole}";
}
