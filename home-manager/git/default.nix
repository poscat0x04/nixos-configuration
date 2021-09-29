{ pkgs, ... }:
let
  gitignore = ./gitignore;
in
{
  programs.git = {
    enable = true;
    userName = "Poscat";
    userEmail = "poscat@mail.poscat.moe";
    lfs.enable = true;
    signing = {
      key = "9341EBC1D730368F2677EAE5B07A14730590D73B";
      signByDefault = true;
    };

    aliases = {
      amend = "commit --amend --no-edit";
    };

    extraConfig = {
      init.defaultBranch = "master";
      core = {
        editor = "nvim";
        excludesFile = "${gitignore}";
      };
      pull.ff = true;
      merge = {
        tool = "nvimdiff";
        conflictstyle = "diff3";
      };
      mergetool.prompt = false;
    };
  };
}
