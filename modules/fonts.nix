{ lib, pkgs, ... }:

{
  fonts = {
    fontconfig = {
      defaultFonts = {
        sansSerif = lib.mkBefore [ "Roboto" "Noto Sans CJK SC" ];
        serif = lib.mkBefore [ "Noto Serif" ];
        monospace = lib.mkBefore [ "Consolas" ];
        emoji = lib.mkBefore [ "Noto Color Emoji" ];
      };
    };
    fonts = with pkgs; [
      emacs-all-the-icons-fonts
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      noto-fonts-extra
      #vistafonts
      ttf-ms-win10
      iosevka
      roboto
    ];
  };
}
