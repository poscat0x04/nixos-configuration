{ ... }:

{
  services.gitolite = {
    enable = true;
    enableGitAnnex = true;
    adminPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKcup9tmRiPbk6wDMOlHLVtlluwbhDXvC7hgUaPnHusD";
  };
}
