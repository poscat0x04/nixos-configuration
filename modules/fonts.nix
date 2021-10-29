{ config, lib, pkgs, ... }:

{
  fonts = {
    enableDefaultFonts = lib.mkForce false;
    fontconfig = {
      defaultFonts = {
        sansSerif = lib.mkBefore [ "Roboto" "Noto Sans CJK SC" ];
        serif = lib.mkBefore [ "Noto Serif" ];
        monospace = lib.mkBefore [ "Consolas" "Noto Sans CJK SC" ];
        emoji = lib.mkBefore [ "Blobmoji" "Noto Color Emoji" ];
      };
    };
    fonts = with pkgs; [
      #emacs-all-the-icons-fonts
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji-blob-bin
      noto-fonts-extra
      ttf-ms-win10
      #iosevka
      #sarasa-gothic
      roboto
    ];
  };
}
