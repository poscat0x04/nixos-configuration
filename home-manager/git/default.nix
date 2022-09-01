{ pkgs, ... }:
let
  gitignore = ./gitignore;
in
{
  programs.git = {
    enable = true;
    userName = "poscat";
    userEmail = "poscat@poscat.moe";
    lfs.enable = true;

    # Use ssh key for signing
    extraConfig.user.signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKcup9tmRiPbk6wDMOlHLVtlluwbhDXvC7hgUaPnHusD";
    extraConfig.commit.gpgSign = true;
    extraConfig.gpg = {
      format = "ssh";
      ssh.allowedSignersFile = "${./allowed_signers}";
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
