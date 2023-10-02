{ ... }:

let
  def = { Detached = false; Buffer = 5000; };
in {
  services.znc = {
    enable = true;
    useLegacyConfig = false;
    mutable = false;
    config = {
      LoadModule = [ "adminlog" "webadmin" ];
      MaxBufferSize = 5000;
      SSLCertFile = "/run/credentials/znc.service/cert.pem";
      SSLKeyFile = "/run/credentials/znc.service/key.pem";
      TrustedProxy = [ "127.0.0.1" "::1" ];
      User.poscat = {
        Admin = true;
        Nick = "poscat";
        AltNick = "poscat0x04";
        RealName = "poscat";
        Ident = "poscat";
        QuitMsg = "Bye";
        LoadModule = [ "chansaver" "controlpanel" "log" ];
        CTCPReply = [
          "CLIENTINFO "
          "SOURCE "
          "TIME "
          "VERSION Konversation 1.9.23081 Copyright 2002-2020 by the Konversation team"
        ];
        AutoClearChanBuffer = false;
        AutoClearQueryBuffer = false;
        Buffer = 5000;
        ChanBufferSize = 5000;
        MaxNetworks = 100;
        Network = {
          libera = {
            Server = "irc.libera.chat +6697";
            LoadModule = [ "block_motd" "simple_away" "sasl" ];
            Chan = {
              "#nixos" = def;
              "#nixos-arrch64" = def;
              "#systemd" = def;
              "#agda" = def;
              "#coq" = def;
              "#haskell" = def;
              "#haskell-in-depth" = def;
              "#idris" = def;
              "#archlinux" = def;
              "#archlinux-cn-game" = def;
              "#fedora" = def;
              "#fedora-devel" = def;
              "#fedora-haskell" = def;
              "#fedora-rust" = def;
              "#fedora-zh" = def;
            };
          };
          orpheus = {
            Server = "irc.orpheus.network +7000";
            LoadModule = [ "simple_away" "sasl" "perform" ];
          };
          redacted = {
            Server = "irc.scratch-network.net +6697";
            LoadModule = [ "simple_away" "nickserv" ];
            Chan = {
              "#RED-help" = def;
            };
          };
        };
        Pass.password = {
          Method = "sha256";
          Hash = "a0440dd6df6d9fef8b659d60ef13ba7ec9a381c624f87e43b579ad0791629a15";
          Salt = "k-4cu+_(;M+bkTQHh(je";
        };
      };
    };
  };

  networking.firewall.allowedTCPPorts = [ 5000 ];

  security.acme.certs."poscat.moe-wildcard".reloadServices = [ "znc.service" ];
  systemd.services.znc = {
    wants = [ "acme-finished-poscat.moe-wildcard.target" ];
    after = [ "acme-finished-poscat.moe-wildcard.target" ];
    serviceConfig = {
      LoadCredential = [
        "cert.pem:/var/lib/acme/poscat.moe-wildcard/cert.pem"
        "key.pem:/var/lib/acme/poscat.moe-wildcard/key.pem"
      ];
      Slice = "system-special-noproxy.slice";
    };
  };
}
