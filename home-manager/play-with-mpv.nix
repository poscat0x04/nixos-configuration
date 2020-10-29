{ pkgs, ... }:

{
  systemd.user.services = {
    play-with-mpv = {
      Service = {
        ExecStart = 
          let script = pkgs.writeShellScript "play-with-mpv-script" ''
            ${pkgs.systemd}/share/factory/etc/X11/xinit/xinitrc.d/50-systemd-user.sh
            ${pkgs.play-with-mpv}/bin/play-with-mpv
          '';
          in
            "${script}";
      };
      Install = {
        WantedBy = [ "default.target" ];
      };
    };
  };
}
