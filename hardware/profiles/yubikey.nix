{ pkgs, ... }:

{
  services = {
    pcscd.enable = true;

    udev.packages = with pkgs; [
      yubikey-personalization
      libu2f-host
    ];
  };
}
