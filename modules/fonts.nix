{ config, lib, pkgs, ... }:

{
  fonts = {
    enableDefaultFonts = lib.mkForce false;
    fontconfig = {
      defaultFonts = {
        sansSerif = lib.mkBefore [ "Microsoft YaHei" "Segoe UI" ];
        serif = lib.mkBefore [ "Cambria" ];
        monospace = lib.mkBefore [ "Consolas" "DejaVu Sans" "Microsoft YaHei" ];
        emoji = lib.mkBefore [ "Blobmoji" "Noto Color Emoji" ];
      };
    };
    fonts = with pkgs; [
      emacs-all-the-icons-fonts
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji-blob-bin
      noto-fonts-extra
      ttf-ms-win10
      sarasa-gothic
      roboto
    ];
  };
}
