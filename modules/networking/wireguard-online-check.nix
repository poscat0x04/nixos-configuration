{ config, pkgs, ... }:

let
  allow-wg = pkgs.writeScript "allow-wg" ''
    #! ${pkgs.nftables}/bin/nft -f
    flush chain inet filter check_wg
    add rule inet filter check_wg iif wg0 accept
  '';
in {
  systemd.targets."wg-online" = {
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
  };
  systemd.services."wg-wait-online" = {
    requires = [
      "systemd-networkd.service"
    ];
    after = [
      "systemd-networkd.service"
    ];
    before = [ "wg-online.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${config.systemd.package}/lib/systemd/systemd-networkd-wait-online -i wg0";
      RemainAfterExit = true;
    };
  };
  systemd.services.nftables-wg = {
    description = "transpraent proxy using nftables";
    wantedBy = [ "multi-user.target" ];
    after = [ "nftables.service" "wg-online.target" ];
    requires = [ "nftables.service" ];
    reloadIfChanged = true;
    unitConfig.ReloadPropagatedFrom = [ "nftables.service" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = allow-wg;
      ExecReload = allow-wg;
      ExecStop = "${pkgs.nftables}/bin/sudo nft flush chain inet filter check_wg";
    };
  };
}
