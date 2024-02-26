{ pkgs, ... }:

{
  # journald
  systemd.services.systemd-journal-flush = {
    requires = [ "zfs-mount.service" ];
    after = [ "zfs-mount.service" ];
    serviceConfig.ExecStartPre = "/run/current-system/sw/bin/sleep 5";
  };

  services.journald = {
    enableHttpGateway = true;
    extraConfig = ''
      Compress=no
      SystemMaxUse=200G
      SystemMaxFileSize=2G
    '';
  };

  # journal-remote
  systemd.additionalUpstreamSystemUnits = [
    "systemd-journal-remote.socket"
    "systemd-journal-remote.service"
  ];

  environment.etc."systemd/journal-remote.conf".text = ''
    [Remote]
    SplitMode=host
  '';

  systemd.sockets.systemd-journal-remote = {
    wantedBy = [ "sockets.target" ];
  };

  users.users.systemd-journal-remote = {
    description = "journal remote sink user";
    isSystemUser = true;
    group = "systemd-journal";
  };

  systemd.services.systemd-journal-remote = {
    serviceConfig = {
      ExecStart = [ "" "${pkgs.systemd}/lib/systemd/systemd-journal-remote --listen-http=-3 --output=/var/log/journal/remote/" ];
      Group = "systemd-journal";
    };
  };
}
