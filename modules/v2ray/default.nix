{ secrets, pkgs, ... }:

{
  services.v2ray = {
    enable = true;
    config = import ./cfg.nix secrets.v2ray-servers;
    package = pkgs.v2ray.override {
      assetOverrides = pkgs.extra-files.v2ray-rules-dat;
    };
  };
}
