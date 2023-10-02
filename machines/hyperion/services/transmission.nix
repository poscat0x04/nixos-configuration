{ pkgs, ... }:

{
  services = {
    transmission = {
      enable = true;
      user = "poscat";
      group = "users";
      home = "/share/torrents/Transmission";
      openPeerPorts = true;
      settings = {
        download-queue-size = 10;
        umask = 18;
        incomplete-dir = "/share/torrents/Transmission/.incomplete";
        download-dir = "/share/torrents/Transmission";
        peer-socket-tos = "lowcost";
        speed-limit-up-enabled = false;

        ratio-limit = 1.4;
        ratio-limit-enabled = true;

        rpc-host-whitelist-enabled = false;
        rpc-whitelist-enabled = false;
        rpc-bind-address = "10.1.10.3";
      };
    };
  };

  systemd.services.transmission.serviceConfig.Slice = "system-noproxy.slice";
}
