{ pkgs, secrets, ... }:

let
  flood-port = 48573;
in {
  services = {
    rtorrent = {
      enable = true;
      package = pkgs.jesec-rtorrent;
      user = "poscat";
      group = "users";
      openFirewall = true;
      dataDir = "/share/torrents/rtorrent/.data";
      downloadDir = "/share/torrents/rtorrent";
      configText = ''
        throttle.max_uploads.global.set = 1000
        throttle.max_downloads.global.set = 1000

        throttle.max_uploads.set = 100
        throttle.max_downloads.set = 100

        throttle.min_peers.normal.set = 199
        throttle.max_peers.normal.set = 200

        throttle.min_peers.seed.set = -1
        throttle.max_peers.seed.set = -1

        trackers.numwant.set = 200
        trackers.use_udp.set = yes

        pieces.memory.max.set = 4096M
        pieces.hash.on_completion.set = yes

        network.max_open_sockets.set = 4096
        network.max_open_files.set = 8192
        network.http.max_open.set = 1024
        network.http.dns_cache_timeout.set = 25

        pieces.preload.type.set = 1
        system.file.allocate.set = 1

        schedule_remove2 = monitor_diskspace
        schedule2 = watch_start, 11, 10, ((load.start_verbose, (cat, (cfg.watch), "start/*.torrent"), "d.delete_tied="))
      '';
    };

    nginx = {
      virtualHosts."torrent.poscat.moe" = {
        onlySSL = true;
        useACMEHost = "poscat.moe-wildcard";
        kTLS = true;
        listen = [
          {
            addr = "0.0.0.0";
            port = 8443;
            ssl = true;
          }
          {
            addr = "[::0]";
            port = 8443;
            ssl = true;
          }
        ];
        locations."/" = {
          proxyPass = "http://127.0.0.1:${builtins.toString flood-port}";
          extraConfig = ''
            auth_digest_user_file ${secrets.http-password-digest};
            auth_digest 'flood';
            auth_digest_expires 600s;
            auth_digest_replays 1024;
          '';
        };
        extraConfig = ''
            auth_digest_shm_size 32m;
        '';
      };
    };
  };

  systemd.services = {
    rtorrent.serviceConfig = {
      LimitNOFILE = "100000";
      CapabilityBoundingSet = "";
      LockPersonality = true;
      NoNewPrivileges = true;
      PrivateDevices = true;
      PrivateTmp = true;
      ProtectHome = true;
      ProtectClock = true;
      ProtectControlGroups = true;
      ProtectHostname = true;
      ProtectKernelLogs = true;
      ProtectKernelModules = true;
      ProtectKernelTunables = true;
      ProtectProc = "invisible";
      ProtectSystem = "full";
      RestrictAddressFamilies = [ "AF_UNIX" "AF_INET" "AF_INET6" ];
      RestrictNamespaces = true;
      RestrictRealtime = true;
      RestrictSUIDSGID = true;
      SystemCallArchitectures = "native";
      SystemCallFilter = [ "@system-service" "~@privileged" ];
      Slice = "system-noproxy.slice";
    };
    flood = {
      wantedBy = [ "multi-user.target" ];
      wants = [ "rtorrent.service" ];
      after = [ "rtorrent.service" ];
      path = [ pkgs.mediainfo ];
      serviceConfig = {
        User = "poscat";
        Group = "users";
        Type = "simple";
        Restart = "always";
        ExecStart = "${pkgs.flood-git}/bin/flood --host 127.0.0.1 --port ${builtins.toString flood-port} --auth none --rtsocket /run/rtorrent/rpc.sock --rundir $STATE_DIRECTORY";
        StateDirectory = "flood";
        StateDirectoryMode = "700";
        CapabilityBoundingSet = "";
        LockPersonality = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateTmp = true;
        ProtectHome = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        ProtectSystem = "strict";
        RestrictAddressFamilies = [ "AF_UNIX" "AF_INET" ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [ "~@privileged" ];
      };
    };
  };
}
