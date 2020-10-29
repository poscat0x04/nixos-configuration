{ ... }:
let
  gitignore = builtins.fetchurl {
    url = "https://www.toptal.com/developers/gitignore/api/intellij,vscode,emacs,vim,linux,macos,git";
    name = "gitignore";
    sha256 = "1h9hsf1qvs1chl4xh43r1255sgcd4mcmiqa1jgfgg5ahsh2irp50";
  };
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

    extraConfig = {
      core = {
        editor = "nvim";
        excludesfile = "${gitignore}";
      };
    };
  };
}
