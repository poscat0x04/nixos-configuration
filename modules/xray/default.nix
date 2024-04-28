{ config, ... }:


{
  sops.secrets.xray-config = {};
  services.xray = {
    enable = true;
    settingsFile = "/run/credentials/xray.service/config.json";
  };

  systemd.services.xray.serviceConfig = {
    LoadCredential = "config.json:${config.sops.secrets.xray-config.path}";
    Slice = "system-noproxy.slice";
  };
}
