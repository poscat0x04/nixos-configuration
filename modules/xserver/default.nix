{ modulesPath, lib, ... }:

{
  imports =
    [
      ./libinput.nix
      ./display-manager
      ./desktop-manager
      ./window-manager
    ];

  services.xserver = {
    enable = true;
    layout = "us";
    xkbOptions = lib.mkDefault "eurosign:e";
  };
}
