# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "thunderbolt" "nvme" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.initrd.luks.devices = {
    cryptpool = {
      device = "/dev/disk/by-uuid/96745a54-cf8e-43f3-8821-bc4f7b9c9007";
      allowDiscards = true;
    };
  };
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "mainpool/root";
      fsType = "zfs";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/0EE8-347F";
      fsType = "vfat";
    };

  fileSystems."/home" =
    { device = "mainpool/home";
      fsType = "zfs";
    };

  networking.wireless.interfaces = [
    "wlp0s20f3"
  ];

  swapDevices = [ ];

  services.fprintd.enable = true;

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
}
