self: super:

let
  extensions = with self.pkgs.vscode-extensions; [
    matklad.rust-analyzer
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
    huytd.nord-light
    akamud.vscode-theme-onelight
    berberman.vscode-cabal-fmt
    Gruntfuggly.todo-tree
    # LDIF
    jtavin.ldif
    # c stuff
    ms-vscode.cmake-tools
    twxs.cmake
    cschlosser.doxdocgen
    llvm-vs-code-extensions.vscode-clangd
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
