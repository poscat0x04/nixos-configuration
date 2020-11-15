{ lib, ... }:

{
  boot.loader = {
    efi.canTouchEfiVariables = true;
    systemd-boot = {
      enable = true;
      configurationLimit = lib.mkDefault 5;
      editor = false;
      memtest86.enable = true;
    };
  };
}
