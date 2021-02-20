{ lib, ... }:

{
  imports = [
    ../../profiles/default.nix
    ../../profiles/desktop.nix
    ../../hardware/profiles/uefi.nix
    ../../hardware/profiles/laptop.nix
    ../../hardware/profiles/intel.nix
    ../../modules/shared-user.nix
    ./hardware-configuration.nix
  ];

  nixos.settings = {
    system.user = "poscat";
    machine = {
      hostname = "thinkcentre";
      undervolt = rec {
        core = -140;
        gpu = -140;
      };
    };
  };
  services.xserver.displayManager.autoLogin.enable = lib.mkForce false;

  networking.hostId = "12345678";

  networking.wireless.enable = lib.mkForce false;

  system.stateVersion = "20.09";
}
