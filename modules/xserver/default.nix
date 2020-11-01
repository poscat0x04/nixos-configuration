{ modulesPath, lib, ... }:

{
  imports =
    [
      ./libinput.nix
      ./display-manager
      ./desktop-manager
      ./window-manager
      ../../patches/nixos/modules/services/x11/desktop-managers
      ../../patches/nixos/modules/services/x11/display-managers
      ../../patches/nixos/modules/services/x11/window-managers
    ];

  disabledModules = [
    "services/x11/desktop-managers/default.nix"
    "services/x11/display-managers/default.nix"
    "services/x11/window-managers/default.nix"
    "services/x11/window-managers/none.nix"
  ];

  services.xserver = {
    enable = true;
    layout = "us";
    xkbOptions = lib.mkDefault "eurosign:e";
  };
}
