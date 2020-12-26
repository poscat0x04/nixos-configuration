{ pkgs, lib, ... }:

{
  imports = [
    ../options/settings
    ../modules/avahi.nix
    ../modules/networking
    ../modules/nix.nix
    ../modules/mtr.nix
    ../modules/openssh.nix
    ../modules/ssh.nix
    ../modules/users.nix
    ../modules/zsh
  ];

  boot = {
    tmpOnTmpfs = true;
    cleanTmpDir = true;
    supportedFilesystems = [ "ntfs" ];
  };

  console.earlySetup = true;

  documentation.dev.enable = true;

  environment = {
    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "code";
      LESSHISTSIZE = "0";
    };

    systemPackages = with pkgs; [
      bat
      customized-neovim
      file
      fzf
      htop
      jq
      ldns
      libarchive
      openssl
      manpages
      nixpkgs-fmt
      nix-index
      nix-prefetch-github
      nix-prefetch-scripts
      pass
      ripgrep
      rnix-lsp
      tree
      unrar
      unzip
      zip
      zstd

      postgresql_13
      pspg

      git

      blktrace
      iotop
      lsof
      nload
      pciutils
      smartmontools
      sysstat
      usbutils
    ];
  };

  i18n = {
    defaultLocale = "en_US.UTF-8";
    supportedLocales = [
      "en_US.UTF-8/UTF-8"
      "ja_JP.UTF-8/UTF-8"
      "zh_CN.UTF-8/UTF-8"
    ];
  };

  console.keyMap = "us";

  services = {
    fstrim.enable = lib.mkDefault true;

    zfs.autoScrub.enable = lib.mkDefault true;
  };

  time.timeZone = "Asia/Shanghai";
}
