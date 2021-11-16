{ pkgs, ... }:

{
  environment.systemPackages = [ pkgs.onedrive ];

  systemd.user.services.onedrive = {
    wantedBy = [ "defualt.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = ''
        ${pkgs.onedrive}/bin/onedrive --monitor
      '';
      Restart = "on-failure";
      RestartSec = 3;
      RestartPreventExitStatus = 3;
    };
  };
}
