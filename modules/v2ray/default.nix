{ secrets, ... }:

{
  services.v2ray = {
    enable = true;
    config = import ./cfg.nix secrets.credentials.v2ray.servers;
  };
}
