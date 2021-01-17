{ ... }:

{
  imports = [
    ../../profiles/default.nix
    ../../profiles/desktop.nix
    ../../hardware/profiles/uefi.nix
    ../../hardware/profiles/laptop.nix
    ../../hardware/profiles/intel.nix
    ./hardware-configuration.nix
  ];

  boot.loader.systemd-boot.consoleMode = "max";

  nixos.settings = {
    system.user = "poscat";
    machine = {
      hostname = "c940";
      undervolt = rec {
        core = -70;
        gpu = -70;
      };
      dpi = 240;
      ihd = true;
    };
  };

  environment.sessionVariables = {
    "PLASMA_USE_QT_SCALING" = "1";
    "GTK_SCALE" = "2";
    "GTK_DPI_SCALE" = "1";
  };

  networking.hostId = "cc0285b2";

  system.stateVersion = "20.03";
}
