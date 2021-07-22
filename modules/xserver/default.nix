{ modulesPath, lib, config, ... }:

let
  dpi = config.nixos.settings.machine.dpi;
in
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
    dpi = lib.mkIf (dpi != null) dpi;
    xkbOptions = lib.mkDefault "eurosign:e";
  };
}
