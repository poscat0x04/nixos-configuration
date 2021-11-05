{ config, pkgs, lib, secrets, ... }:

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
    ../modules/avahi.nix
    ../modules/chromium.nix
    ../modules/firefox.nix
    ../modules/fonts.nix
    ../modules/gnupg.nix
    ../modules/im.nix
    ../modules/lorri.nix
    ../modules/rust.nix
    ../modules/unbound.nix
    ../modules/v2ray
    ../modules/xserver
    ../modules/networking/firewall.nix
    ../hardware/profiles/wacom.nix
    ../hardware/profiles/yubikey.nix
    ./default.nix
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
    extraModprobeConfig = ''
      options hid_apple fnmode=2
    '';
  };

  environment = {
    systemPackages = with pkgs; [
      # WPA_supplicant
      wpa_supplicant_gui
      # VCS
      gitAndTools.gh
      #darcs
      pijul
      # Editors
      #customized-emacs
      (neovim-qt.override {
        neovim = config.programs.neovim.finalPackage;
      })
      vscode-with-extensions
      # Consoles
      alacritty
      # IMs
      tdesktop
      discord
      #konversation
      # LaTeX
      (texlive.combine {
        inherit (texlive) scheme-full;
        inherit jhwhw-tex;
      })
      # Build Tools
      gnumake
      gcc
      cmake
      clang-tools
      binutils-unwrapped
      # ATS
      ats2
      # Dhall
      #dhall
      #dhall-lsp-server
      # Misc
      anki
      ark
      #krita
      thunderbird
      qimgv
      transmission-qt
      zotero
      zathura
      akregator
      # Utils
      bench
      tokei
      flameshot
      flamegraph
      graphviz
      shellcheck
      youtube-dl
      profile-cleaner
      #postman
      standardnotes
      hinit
      mpv
      jetbrains.clion
      jetbrains.idea-ultimate
      jetbrains.datagrip
      bitwarden
    ] ++ haskell-packages;
  };

  home-manager.users."${config.nixos.settings.system.user}" = lib.mkForce ({ ... }: {
    _module.args = { sysConfig = config; inherit secrets; };
    imports = [
      ../home-manager/profiles
      ../home-manager/profiles/desktop.nix
    ];
  });

  services.printing.enable = true;

  console = {
    font = if dpi != null && dpi >= 196 then "ter-u28n" else "ter-u18n";
    packages = [ pkgs.terminus_font ];
  };
}
