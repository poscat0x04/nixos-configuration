{ nixosModules, ... }:

{
  imports = [
    nixosModules.genshin-checkin
  ];

  services.genshin-checkin = {
    enable = true;
    ltuid = "220329954";
    ltoken = "XcEzLNw50itltnthBghiUgkEJ846DaL64I7c5dH9";
  };
}
