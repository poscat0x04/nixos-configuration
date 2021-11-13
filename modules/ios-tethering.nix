{ pkgs, ... }:

{
  environment.systemPackages = [
    pkgs.libimobiledevice
  ];

  services.usbmuxd.enable = true;
}
