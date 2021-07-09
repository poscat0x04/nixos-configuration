{ config, lib, pkgs, ... }:

let
  dpi = config.nixos.settings.machine.dpi;
in
  {
    fonts = {
      enableDefaultFonts = lib.mkForce false;
      fontconfig = {
        defaultFonts = {
          sansSerif = lib.mkBefore [ "Roboto" "Noto Sans CJK SC" ];
          serif = lib.mkBefore [ "Noto Serif" ];
          monospace = lib.mkBefore [ "Consolas" ];
          emoji = lib.mkBefore [ "Blobmoji" "Noto Color Emoji" ];
        };
        dpi = lib.mkIf (dpi != null) dpi;
      };
      fonts = with pkgs; [
        emacs-all-the-icons-fonts
        noto-fonts
        noto-fonts-cjk
        noto-fonts-emoji-blob-bin
        noto-fonts-extra
        ttf-ms-win10
        iosevka
        sarasa-gothic
        roboto
      ];
    };
  }
