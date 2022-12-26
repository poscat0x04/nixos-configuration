{ config, pkgs, lib, secrets, ... }:

let
  haskell-packages = with pkgs.haskellPackages; map pkgs.haskell.lib.justStaticExecutables [
    cabal-fmt
    hp2pretty
    ghc-prof-flamegraph
  ];
in

{
  imports = [
    ../modules/agda.nix
    ../modules/fonts.nix
    ../modules/im.nix
    ../modules/lorri.nix
    ../modules/rust.nix
    ../modules/unbound.nix
    ../modules/v2ray
    ../modules/onedrive.nix
    ./default.nix
  ];

  boot = {
    consoleLogLevel = 3;

    kernelParams = [
      # Silent boot
      "quiet"
    ];
  };

  environment = {
    systemPackages = with pkgs; [
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
      #krita
      zotero
      zathura
      # Utils
      pandoc
      bench
      tokei
      flameshot
      flamegraph
      graphviz
      shellcheck
      youtube-dl
      python3Packages.pygments
      hinit
    ] ++ haskell-packages;
  };

  home-manager.users."${config.nixos.settings.system.user}" = lib.mkForce ({ ... }: {
    _module.args = { sysConfig = config; inherit secrets; };
    imports = [
      ../home-manager/profiles
      ../home-manager/alacritty.nix
      #../home-manager/emacs.nix
      ../home-manager/code
    ];
  });
}
