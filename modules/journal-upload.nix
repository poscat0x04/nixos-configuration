{ ... }:

{
  environment.etc."systemd/journal-upload.conf".text = ''
    [Upload]
    URL=http://10.1.10.3:19532
  '';

  systemd.additionalUpstreamSystemUnits = [ "systemd-journal-upload.service" ];

  systemd.services.systemd-journal-upload = {
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Restart = "always";
      RestartSec = "2s";
    };
  };
}
