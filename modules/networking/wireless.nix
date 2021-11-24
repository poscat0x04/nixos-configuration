{ secrets, ... }:

{
  networking.wireless = {
    enable = true;
    userControlled.enable = true;
    networks = secrets.wireless-networks;
    scanOnLowSignal = false;
    extraConfig = ''
      bgscan="simple:5:-70:3600"
      fast_reauth=1
      ap_scan=1
    '';
  };
}
