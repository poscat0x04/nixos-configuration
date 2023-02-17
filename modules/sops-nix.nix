{ config, nixosModules, ... }:

let
  machine = config.nixos.settings.machine.hostname;
in {
  imports = [ nixosModules.sops ];

  sops = {
    defaultSopsFile = ../secrets + "/${machine}.yaml";
    age = {
      sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
      generateKey = false;
    };
  };
}
