self: super:

let
  extensions = with self.pkgs.vscode-extensions; [
    redhat.vscode-yaml
    vscodevim.vim
    bbenoist.Nix
    matklad.rust-analyzer
    ms-python.python
    justusadam.language-haskell
    dhall.dhall-lang
    dhall.vscode-dhall-lsp-server

    haskell.haskell
    banacorn.agda-mode
    serayuzgur.crates
    arcticicestudio.nord-visual-studio-code
    PKief.material-icon-theme
    dbaeumer.vscode-eslint
    timonwong.shellcheck
    wayou.vscode-todo-highlight
  ];
in
  {
    vscode-insiders-with-extensions = super.vscode-insiders-with-extensions.override {
      vscodeExtensions = extensions;
    };
  }
