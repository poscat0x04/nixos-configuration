self: super:

let
  extensions = with self.pkgs.vscode-extensions; [
    matklad.rust-analyzer
    ms-python.python

    redhat.vscode-yaml
    vscodevim.vim
    bbenoist.Nix
    justusadam.language-haskell
    dhall.dhall-lang
    dhall.vscode-dhall-lsp-server
    haskell.haskell
    banacorn.agda-mode
    serayuzgur.crates
    JScearcy.rust-doc-viewer
    arcticicestudio.nord-visual-studio-code
    PKief.material-icon-theme
    dbaeumer.vscode-eslint
    timonwong.shellcheck
    wayou.vscode-todo-highlight
    maximedenes.vscoq
    james-yu.latex-workshop
    GitHub.vscode-pull-request-github
    mr-konn.generic-input-method
  ];
in
  {
    vscode-insiders-with-extensions = super.vscode-insiders-with-extensions.override {
      vscodeExtensions = extensions;
    };
  }
