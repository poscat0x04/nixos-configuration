{ pkgs, lib, ... }:

{
  imports = [
    ../options/settings
    ../modules/networking
    ../modules/nix.nix
    ../modules/mtr.nix
    ../modules/openssh.nix
    ../modules/ssh.nix
    ../modules/users.nix
    ../modules/neovim.nix
    ../modules/zsh
  ];

  boot = {
    tmpOnTmpfs = true;
    cleanTmpDir = true;
    supportedFilesystems = [ "ntfs" ];
    zfs.enableUnstable = true;
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [
      "msr.allow_writes=on"
    ];
  };

  console.earlySetup = true;

  documentation.dev.enable = true;

  environment = {
    sessionVariables = {
      VISUAL = "code";
      LESSHISTSIZE = "0";
      PSQL_PAGER = "pspg";
      NIX_SSHOPTS = "-t";
    };

    systemPackages = with pkgs; [
      bat
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

      postgresql_14
      pspg

      git

      gnupg

      blktrace
      iotop
      lsof
      nload
      pciutils
      smartmontools
      sysstat
      usbutils
      lm_sensors
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
