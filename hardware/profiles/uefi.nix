{ lib, ... }:

{
  boot.loader = {
    efi.canTouchEfiVariables = true;
    systemd-boot = {
      enable = true;
      consoleMode = lib.mkDefault "max";
      configurationLimit = lib.mkDefault 5;
      editor = false;
      memtest86.enable = true;
    };
  };
}
