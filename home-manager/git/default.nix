{ pkgs, ... }:
let
  gitignore = ./gitignore;
in
{
  programs.git = {
    enable = true;
    userName = "Poscat";
    userEmail = "poscat@poscat.moe";
    lfs.enable = true;

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
