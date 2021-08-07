{ secrets, ... }:

{
  services.v2ray = {
    enable = true;
    config = import ./cfg.nix secrets.v2ray-servers;
  };
}
