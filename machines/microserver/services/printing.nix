{ pkgs, ... }:

{
  services.printing = {
    enable = true;
    browsing = true;
    defaultShared = true;
    allowFrom = [ "all" ];
    listenAddresses = [ "10.1.10.1:631" ];
    drivers = with pkgs; [ epson-escpr ];
  };
}
