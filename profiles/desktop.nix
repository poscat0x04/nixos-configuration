{ pkgs, lib, ... }:

{
  imports = [
    ../modules/agda.nix
    ../modules/audio.nix
    ../modules/chromium.nix
    ../modules/firefox.nix
    ../modules/fonts.nix
    ../modules/gnupg.nix
    ../modules/im.nix
    ../modules/lorri.nix
    ../modules/privacy-haters.nix
    ../modules/unbound.nix
    ../modules/v2ray
    ../modules/xserver
    ../hardware/profiles/wacom.nix
    ../hardware/profiles/yubikey.nix
  ];

  boot = {
    consoleLogLevel = 3;

    kernelParams = [
      # Silent boot
      "quiet"
      # Trust RDRAND
      "random.trust_cpu=on"
      # Turn off CPU mitigations
      "mitigations=off"
    ];

    plymouth.enable = true;
  };

  environment = {
    systemPackages = with pkgs; [
      # VCS
      gitAndTools.gh
      darcs
      # Editors
      customized-neovim-qt
      # Consoles
      alacritty
      # IMs
      tdesktop
      # LaTeX
      # commented due to #101459
      # texlive.combined.scheme-full
      # Build Tools
      gnumake
      # Rust
      rust-analyzer
      # ATS
      ats2
      # Dhall
      dhall
      dhall-lsp-server
      # Misc
      anki
      thunderbird
      qimgv
      transmission-qt
      zotero
      zathura
      # Utils
      loc
      lm_sensors
      flameshot
      ffsend
      shellcheck
      youtube-dl
      profile-cleaner
    ];
  };

 security.rngd.enable = false;

 services.printing.enable = true;

 console = {
    font = "ter-u28n";
    packages = [ pkgs.terminus_font ];
  };
}
