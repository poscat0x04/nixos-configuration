{
  systemd.services.systemd-journal-flush = {
    requires = [ "zfs-mount.service" ];
    after = [ "zfs-mount.service" ];
  };

  services.journald = {
    enableHttpGateway = true;
    extraConfig = ''
      Compress=no
      SystemMaxUse=200G
      SystemMaxFileSize=2G
    '';
  };
}
