{ lib, pkgs, ... }:

let
  rust-stable = pkgs.rust-bin.nightly."2021-10-01".minimal.override {
    extensions = [
      "rust-src"
      "rustfmt-preview"
      "clippy-preview"
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
