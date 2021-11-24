{ ... }:

{
  xdg.configFile = {
    "Code/User/snippets".source = ./snippets;
    "Code/User/settings.json".text = builtins.toJSON (import ./settings.nix);
  };
}
