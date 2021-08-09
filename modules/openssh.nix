{ config, lib, ... }:

let
  uname = config.nixos.settings.system.user;
in
{
  services.openssh = {
    enable = true;
    permitRootLogin = "no";
    passwordAuthentication = false;
    challengeResponseAuthentication = false;
    banner = ''
          _   ___      ____  _____
         / | / (_)  __/ __ \/ ___/
        /  |/ / / |/_/ / / /\__ \
       / /|  / />  </ /_/ /___/ /
      /_/ |_/_/_/|_|\____//____/

    '';
    extraConfig = ''
      StreamLocalBindUnlink yes
    '';
  };

  users.users."${uname}".openssh.authorizedKeys.keys = lib.mkAfter [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC+bAe7i9JTF1kG7vg2xcg8wm6dDQmVlFS3Yf+xyy9gCBvhPnx+UY2aUWIT33HMjUvMPZHUaDmmUS2iCAbNRFX3LLRX55uIqRAPI9/6QQJnOt2piptpbtwRzzP3PC+vYHa8jF3fLINSrvBt0XLp4DyZayVWtngaKH6exNNBbwzsTfQXGb36sz3jd2f199k9JDsjnBpWFZYaPIBKgWxLpAWrFclJYSZ3p3LC22u2V0HzVM0z0dZmeGzaCU8Yh5CvHJ34RR8aAZ7pV9JLrns4g8uMwIt04/Cv0ccnuIQz5AIL/m5F1ZaMM9rl6/8LHr6EzOoYLgDNbAOoN0eVO7SK/WIoIoC3eie1w0F0xFJHrNi42l9Yw+OBGEXcnoDUrOpTb05Dp7ssSgAuN13L9EJViwO0xyrkudW8m6Sn9fCQq/mNOoD7ObtTuH5Y7PWh3fUUqdcPLsF+v1QfVWhl895py5+cmKNI2JS9FiC4wnoZUZb9KUwZhhPNK0HWEZitirRbh/bqE4ljx+bkxN0s5cwln5XuLnlVHC4SDRdgrgcOtw63+hMXyAUTsjJVaV31liJKPjXCAS8zDd6AkvLlQlc9O907oIbcVjzrj3K25OztBE9Z9hcfQJLxyJ2MOChHDY6Nhn6ERUCB0WzMR1gd/pIHa8AucTLO/UGplX0zI0FwcUh/kw== openpgp:0xEF00962F"
  ];
}
