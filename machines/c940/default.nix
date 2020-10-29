{ ... }:

{
  imports = [
    ../../profiles/default.nix
    ../../profiles/desktop.nix
    ../../hardware/profiles/uefi.nix
    ../../hardware/profiles/laptop.nix
    ../../hardware/profiles/intel.nix
    ../../hardware/machines/c940/thermald
    ./hardware-configuration.nix
  ];

  nixos.settings = {
    system.user = "poscat";
    machine = {
      hostname = "c940";
      undervolt = rec {
        core = -70;
        gpu = -70;
      };
    };
  };

  fonts.fontconfig.dpi = 240;

  environment.sessionVariables = {
    "LIBVA_DRIVER_NAME" = "iHD";
    "PLASMA_USE_QT_SCALING" = "1";
    "GTK_SCALE" = "2";
    "GTK_DPI_SCALE" = "1";
  };

  networking.hostId = "1242827d";

  system.stateVersion = "20.03";
}
