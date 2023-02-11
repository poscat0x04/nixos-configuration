{ config, lib, pkgs, ... }:

let
  cfg = config.networking.pppoe;
in {
  options.networking.pppoe = with lib; {
    enable = mkEnableOption ''
      Whether to enable pppoe service
    '';

    ifname = mkOption {
      type = types.str;
      default = "ppp0";
    };

    underlyingIF = mkOption {
      type = types.str;
    };

    user = mkOption {
      type = types.str;
    };

    password = mkOption {
      type = types.str;
    };
  };

  config = lib.mkIf cfg.enable {
    services.pppd = {
      enable = true;
      peers.pppoe = {
        config = ''
          plugin pppoe.so
          ifname ${cfg.ifname}
          nic-${cfg.underlyingIF}

          lcp-echo-failure 5
          lcp-echo-interval 1
          maxfail 1

          mru 1492
          mtu 1492

          user ${cfg.user}
          password ${cfg.password}

        '';
        autostart = true;
      };
    };

    environment.etc."ppp/ip-up" = {
      mode = "0555";
      text = ''
        #!/bin/sh
        ${pkgs.systemd}/bin/networkctl reconfigure $1
      '';
    };
  };
}
