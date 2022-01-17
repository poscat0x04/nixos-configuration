{ secrets, ... }:

{
  networking.wireless = {
    enable = true;
    userControlled.enable = true;
    networks = secrets.wireless-networks;
    scanOnLowSignal = false;
    extraConfig = ''
      bgscan="learn:5:-70:300:/run/wpa_supplicant/wireless.bgscan"
      autoscan="periodic:5"
      fast_reauth=1
      ap_scan=1
    '';
  };
}
