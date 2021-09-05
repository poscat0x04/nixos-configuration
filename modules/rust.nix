{ lib, pkgs, ... }:

let
  rust-stable = pkgs.rust-bin.nightly.latest.minimal.override {
    extensions = [
      "rust-src"
      "rustfmt-preview"
      "clippy-preview"
    ];
  };
in
{
  environment.systemPackages = with pkgs; [
    nocargo.nocargo.bin
    rust-stable
    rust-analyzer
    cargo-asm
    cargo-bloat
    cargo-flamegraph
  ];
}
