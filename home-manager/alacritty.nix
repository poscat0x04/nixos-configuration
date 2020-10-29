{ pkgs, ... }:

let
  theme = builtins.fromJSON (builtins.readFile "${pkgs.alacritty-nord}");
  base_settings = {
    window.startup_mode = "Maximized";

    background_opacity = 0.85;

    font = {
      normal.family = "Consolas";
      size = 13;
    };

    env.TERM = "xterm-256color";
  };
in
  {
    programs.alacritty = {
      enable = true;
      settings = base_settings // theme; 
    };
  }
