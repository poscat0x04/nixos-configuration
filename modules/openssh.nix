{ config, lib, ... }:

let
  uname = config.nixos.settings.system.user;
in
{
  services.openssh = {
    enable = true;
    banner = ''
          _   ___      ____  _____
         / | / (_)  __/ __ \/ ___/
        /  |/ / / |/_/ / / /\__ \
       / /|  / />  </ /_/ /___/ /
      /_/ |_/_/_/|_|\____//____/

    '';
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      X11Forwarding = true;
    };
    extraConfig = ''
      StreamLocalBindUnlink yes
    '';
  };

  users.users."${uname}".openssh.authorizedKeys.keys = lib.mkAfter [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICatYs6qNpoIgNMDcGuJKNDfg3m7JWg3KHGL73rw2GCr openpgp:0x48271015"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKcup9tmRiPbk6wDMOlHLVtlluwbhDXvC7hgUaPnHusD poscat"
  ];
}
