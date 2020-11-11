{ nixosModules, config, pkgs, ... }:

with config.nixos;
{
  imports = [
    nixosModules.home-manager
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users."${settings.system.user}" = { ... }: {
      _module.args = { sysConfig = config; };
      imports = [ ../home-manager ];
    };
  };

  users = {
    users = {
      "${settings.system.user}" = {
        uid = 1000;
        createHome = true;

        home = settings.system.home;
        hashedPassword = settings.system.password;

        group = "users";
        extraGroups = [
          "wheel"
          "systemd-journal"
        ];

        shell = pkgs.zsh;
      };
    };
    mutableUsers = false;
  };
}
