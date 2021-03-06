{ config, pkgs, lib, ... }:

let
  dpi = config.nixos.settings.machine.dpi;
  haskell-packages = with pkgs.haskellPackages; map pkgs.haskell.lib.justStaticExecutables [
    cabal-fmt
    hp2pretty
    ghc-prof-flamegraph
  ];
in

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
    ../modules/rust.nix
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
      #customized-emacs
      customized-neovim-qt
      vscode-with-extensions
      # Consoles
      alacritty
      # IMs
      tdesktop
      discord
      konversation
      # LaTeX
      texlive.combined.scheme-full
      # Build Tools
      gnumake
      gcc
      cmake
      clang
      clang-tools
      binutils-unwrapped
      # ATS
      ats2
      # Dhall
      dhall
      dhall-lsp-server
      # Misc
      anki
      ark
      krita
      thunderbird
      qimgv
      transmission-qt
      zotero
      zathura
      # Utils
      bench
      tokei
      lm_sensors
      flameshot
      flamegraph
      graphviz
      shellcheck
      youtube-dl
      profile-cleaner
      postman
      standardnotes
      hinit
    ] ++ haskell-packages;
  };

 services.printing.enable = true;

 console = {
    font = if dpi != null && dpi >= 196 then "ter-u28n" else "ter-u18n";
    packages = [ pkgs.terminus_font ];
  };
}
