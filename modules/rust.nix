{ lib, pkgs, ... }:

let
  rust-stable = pkgs.rust-bin.stable.latest.minimal.override {
    extensions = [
      "rust-src"
      "rust-analyzer"
    ];
  };
in
{
  environment.systemPackages = [ rust-stable ];
}
