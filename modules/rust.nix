{ lib, pkgs, ... }:

let
  rust-stable = pkgs.rust-bin.stable.latest.minimal.override {
    extensions = [
      "rust-src"
      "rustfmt-preview"
      "clippy-preview"
      "rls-preview"
    ];
  };
in
{
  environment.systemPackages = with pkgs; [
    rust-stable
    rust-analyzer
    cargo-asm
    cargo-bloat
    cargo-flamegraph
  ];
}
