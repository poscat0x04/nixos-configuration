{ config, pkgs, lib, ... }:

{
  imports = [
    ../options/settings
    ../modules/networking
    ../modules/nix.nix
    ../modules/memory.nix
    ../modules/mtr.nix
    ../modules/openssh.nix
    ../modules/ssh.nix
    ../modules/users.nix
    ../modules/neovim
    ../modules/zsh
  ];

  boot = {
    # We have compression
    runSize = "200%";
    tmp = {
      useTmpfs = true;
      cleanOnBoot = true;
      tmpfsSize = "100%";
    };
    supportedFilesystems = [ "ntfs" ];
    kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
    kernelParams = [
      # Trust RDRAND
      "random.trust_cpu=on"
      # Turn off CPU mitigations
      "mitigations=off"
    ];
    kernel.sysctl = {
      "kernel.kexec_load_disabled" = 1;
      "kernel.kptr_restrict" = 2;
      "net.ipv4.conf.all.accept_redirects" = false;
      "net.ipv4.conf.default.accept_redirects" = false;
      "net.ipv4.conf.all.secure_redirects" = false;
      "net.ipv4.conf.default.secure_redirects" = false;
      "net.ipv6.conf.all.accept_redirects" = false;
      "net.ipv6.conf.default.accept_redirects" = false;
      "net.ipv4.conf.all.send_redirects" = false;
      "net.ipv4.conf.default.send_redirects" = false;
      "net.ipv4.conf.default.log_martians" = false;
      "net.ipv4.conf.all.log_martians" = false;
    };
  };

  console.earlySetup = true;

  documentation.dev.enable = true;

  environment = {
    sessionVariables = {
      VISUAL = "code";
      LESSHISTSIZE = "0";
      PSQL_PAGER = "pspg";
      NIX_SSHOPTS = "-t";
      GRIPHOME = "~/.config/grip";
    };

    systemPackages = with pkgs; [
      bat
      du-dust
      file
      fd
      fzf
      htop
      jq
      ldns
      libarchive
      openssl
      man-pages
      nixpkgs-fmt
      nix-index
      nix-prefetch-github
      nix-prefetch-scripts
      pass
      ripgrep
      tree
      unrar
      unzip
      zip
      zstd

      age
      sops
      ssh-to-age

      nil
      attic-client

      wireguard-tools

      postgresql_15
      pspg

      git

      blktrace
      iotop
      lsof
      nload
      pciutils
      smartmontools
      hdparm
      sysstat
      usbutils
      lm_sensors
      libhugetlbfs.bin
    ];
  };

  i18n = {
    defaultLocale = "en_US.UTF-8";
    supportedLocales = [
      "en_US.UTF-8/UTF-8"
      "en_DK.UTF-8/UTF-8"
      "ja_JP.UTF-8/UTF-8"
      "zh_CN.UTF-8/UTF-8"
    ];
    extraLocaleSettings = {
      LC_TIME = "en_DK.UTF-8";
      LC_PAPER = "en_DK.UTF-8";
      LC_MEASUREMENT = "en_DK.UTF-8";
    };
  };

  console.keyMap = "us";

  services = {
    fstrim.enable = lib.mkDefault true;

    zfs.autoScrub.enable = lib.mkDefault true;
  };

  programs.nix-ld.enable = true;

  time.timeZone = "Asia/Shanghai";
}
