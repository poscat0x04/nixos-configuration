{ lib, ... }:

{
  imports = [
    ../../profiles/desktop.nix
    ../../hardware/profiles/uefi.nix
    ../../hardware/profiles/laptop.nix
    ../../hardware/profiles/intel.nix
    ../../hardware/profiles/thinkpad.nix
    ../../modules/networking/wireless.nix
    ../../modules/networking/wireguard.nix
    ./hardware-configuration.nix
  ];

  boot.loader.systemd-boot.consoleMode = "max";

  nixos.settings = {
    system.user = "poscat";
    machine = {
      hostname = "x1c";
      dpi = 240;
      ihd = true;
    };
  };

  environment.sessionVariables = {
    "PLASMA_USE_QT_SCALING" = "1";
    "GDK_SCALE" = "2";
    "GDK_DPI_SCALE" = "0.5";
  };

  networking.hostId = "0edb8488";

  networking.tproxy.enable = false;

  system.stateVersion = "21.11";
}
