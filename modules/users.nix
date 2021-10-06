{ nixosModules, config, pkgs, secrets, ... }:

with config.nixos;
{
  imports = [
    nixosModules.home-manager
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users."${settings.system.user}" = { ... }: {
      _module.args = { sysConfig = config; inherit secrets; };
      imports = [ ../home-manager/profiles ];
    };
  };

  users = {
    users = {
      "${settings.system.user}" = {
        uid = 1000;
        createHome = true;
        isNormalUser = true;

        home = settings.system.home;
        hashedPassword = settings.system.password;

        group = "users";
        extraGroups = [
          "wheel"
          "systemd-journal"
        ];

        shell = pkgs.zsh;
      };
      root = {
        hashedPassword = settings.system.password;
      };
    };
    mutableUsers = false;
  };
}
