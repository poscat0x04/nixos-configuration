# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "ehci_pci" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "mainpool/root";
      fsType = "zfs";
    };

  fileSystems."/home" =
    { device = "mainpool/home";
      fsType = "zfs";
    };

  fileSystems."/var/lib/machines/arch" = {
    device = "mainpool/containers/arch";
    fsType = "zfs";
  };

  fileSystems."/var/lib/postgresql" = {
    device = "mainpool/postgres";
    fsType = "zfs";
  };

  fileSystems."/var/lib/znc" = {
    device = "mainpool/znc";
    fsType = "zfs";
  };

  fileSystems."/shares/poscat" = {
    device = "mainpool/storage/share/poscat";
    fsType = "zfs";
  };

  fileSystems."/shares/poscat/Torrents" = {
    device = "mainpool/storage/torrents";
    fsType = "zfs";
  };

  fileSystems."/shares/timemachine" = {
    device = "mainpool/storage/share/timemachine";
    fsType = "zfs";
  };

  fileSystems."/srv" = {
    device = "mainpool/storage/web";
    fsType = "zfs";
  };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/67DB-A2F4";
      fsType = "vfat";
    };

  swapDevices = [ ];

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
}
