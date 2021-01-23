{ lib, pkgs, ... }:

let
  rust-stable = pkgs.rust-bin.stable.latest.rust.override {
    extensions = [ "rust-src" ];
  };
in
{
  environment.systemPackages = [
    rust-stable
  ];

  nixpkgs.overlays = lib.singleton (final: prev: {
    vscode-extensions = prev.vscode-extensions // {
      matklad.rust-analyzer = prev.vscode-extensions.matklad.rust-analyzer.override {
       rust-analyzer = rust-stable;
      };
    };
  });
}
