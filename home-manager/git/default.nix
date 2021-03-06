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
      key = "48ADDE10F27BAFB47BB0CCAF2D2595A00D08ACE0";
      signByDefault = true;
    };

    aliases = {
      amend = "commit --amend --no-edit";
    };

    extraConfig = {
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
