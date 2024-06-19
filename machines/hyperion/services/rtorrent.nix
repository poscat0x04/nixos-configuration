{ pkgs, ... }:

let
  flood-port = 48573;
in {
  environment.systemPackages = [ pkgs.pyrosimple ];
  networking.firewall.allowedUDPPorts = [ 6881 ];
  services = {
    rtorrent = {
      enable = true;
      package = pkgs.rtorrent;
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

        dht = auto
        dht_port = 6881
        protocol.pex.set= yes
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
          proxyPass = "http://127.0.0.1:${toString flood-port}";
          recommendedProxySettings = true;
          extraConfig = ''
            access_by_lua_block {
              local opts = {
                redirect_uri_path = "/callback",
                discovery = "https://git.poscat.moe:8443/.well-known/openid-configuration",
                client_id = "9b136a46-a695-4319-8eb2-05816b0a9c1c",
                client_secret = secret.rtorrent_client_secret,
                ssl_verify = "yes",
                scope = "openid email profile groups",
                redirect_uri_scheme = "https",
              }

              local res, err = require("resty.openidc").authenticate(opts)

              if err then
                ngx.status = 500
                ngx.say(err)
                ngx.log(ngx.STDERR, opts.client_secret)
                ngx.log(ngx.STDERR, err)
                ngx.exit(ngx.HTTP_INTERNAL_SERVER_ERROR)
              end

              if res.user.preferred_username ~= "poscat" then
                ngx.status = 403
                ngx.say('Access Denied')
                ngx.exit(ngx.HTTP_FORBIDDEN)
              end

              ngx.req.set_header("X-USER", res.id_token.sub)
            }
          '';
        };
        extraConfig = ''
          error_page 497 301 =307 https://$host:$server_port$request_uri;
          add_header Strict-Transport-Security 'max-age=31536000' always;
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
        ExecStart = "${pkgs.flood-git}/bin/flood --host 127.0.0.1 --port ${toString flood-port} --auth none --rtsocket /run/rtorrent/rpc.sock --rundir $STATE_DIRECTORY";
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
        ReadWritePaths = [ "/share/torrents" ];
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
