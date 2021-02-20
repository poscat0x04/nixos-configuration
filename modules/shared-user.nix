{ nixosModules, config, pkgs, ... }:

{
  users = {
    users = {
      shared = {
        uid = 2000;
        createHome = true;

        home = "/home/shared";
        hashedPassword = "";

        group = "users";
        extraGroups = [
          "systemd-journal"
        ];

        shell = pkgs.zsh;
      };
    };
  };
}
