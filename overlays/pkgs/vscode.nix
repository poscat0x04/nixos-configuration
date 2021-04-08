self: super:

let
  extensions = with self.pkgs.vscode-extensions; [
    rust-lang.rust
    vadimcn.vscode-lldb
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
    christian-kohler.path-intellisense
    aaronduino.nix-lsp
    ms-vscode.hexeditor
    be5invis.toml
    jroesch.lean
  ];
in
  {
    vscode-insiders-with-extensions = super.vscode-insiders-with-extensions.override {
      vscodeExtensions = extensions;
    };
    vscode-with-extensions = super.vscode-with-extensions.override {
      vscodeExtensions = extensions;
    };
  }
