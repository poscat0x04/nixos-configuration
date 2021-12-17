{ lib, ... }:

{
  imports = [
    ../../profiles/vm.nix
    ../../hardware/profiles/uefi.nix
    ./hardware-configuration.nix
  ];

  boot.loader.systemd-boot.consoleMode = "max";

  nixos.settings = {
    system.user = "poscat";
    machine = {
      hostname = "x1c-hv";
      #dpi = 240;
    };
  };

  environment.sessionVariables = {
    "PLASMA_USE_QT_SCALING" = "1";
    "GDK_SCALE" = "2";
    "GDK_DPI_SCALE" = "0.5";
  };

  #networking.tproxy.enable = true;

  system.stateVersion = "21.11";
}
