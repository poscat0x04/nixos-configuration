{ ... }:

{
  imports = [
    ../../profiles/default.nix
    ../../profiles/desktop.nix
    ../../hardware/profiles/uefi.nix
    ../../hardware/profiles/laptop.nix
    ../../hardware/profiles/intel.nix
    ../../hardware/profiles/thinkpad.nix
    ./hardware-configuration.nix
  ];

  boot.loader.systemd-boot.consoleMode = "max";

  nixos.settings = {
    system.user = "poscat";
    machine = {
      hostname = "x1ygen6";
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
    "GDK_SCALE" = "2";
    "GDK_DPI_SCALE" = "1";
  };

  networking.hostId = "2166050a";

  system.stateVersion = "21.11";
}
