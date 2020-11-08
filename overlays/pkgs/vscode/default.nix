self: super:

with builtins;

let
  extensions = with self.pkgs; with vscode-extensions; with vscode-utils; [
    redhat.vscode-yaml
    vscodevim.vim
    bbenoist.Nix
    matklad.rust-analyzer
    ms-python.python
    justusadam.language-haskell
    dhall.dhall-lang
    dhall.vscode-dhall-lsp-server
  ] ++ extensionsFromVscodeMarketplace (fromJSON (readFile ./extensions.json));
in
  {
    vscode-insiders-with-extensions = super.vscode-insiders-with-extensions.override {
      vscodeExtensions = extensions;
    };
  }
