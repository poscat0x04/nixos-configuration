{ secrets, ... }:

{
  networking.wireless = {
    enable = true;
    userControlled.enable = true;
    networks = secrets.wireless-networks;
  };
}
