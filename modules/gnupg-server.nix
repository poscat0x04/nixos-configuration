{ config, ... }:

{
  systemd.user.services.gpg-create-dir = {
    enable = true;
    wantedBy = [ "default.target" ];
    serviceConfig = {
      ExecStart = "${config.programs.gnupg.package}/bin/gpgconf --create-socketdir";
      Type = "oneshot";
      RemainAfterExit = true;
    };
  };
}
