{ ... }:

{
  services.xserver.desktopManager = {
    plasma5 = {
      enable = true;
      phononBackend = "vlc";
    };
  };

  environment.sessionVariables = {
    "PLASMA_USE_QT_SCALING" = "1";
  };
}
