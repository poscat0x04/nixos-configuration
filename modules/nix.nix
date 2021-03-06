{ secrets, flakes, pkgs, config, lib, ... }:

let
  flakesEmpty = pkgs.writeText "flakes-empty.json" (builtins.toJSON { flakes = []; version = 2; });
in

{
  nix = {
    extraOptions = ''
      experimental-features = flakes nix-command
      access-tokens = github.com=${secrets.credentials.github}
      flake-registry = ${flakesEmpty}
    '';

    binaryCaches = [
      "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
      "https://nix-community.cachix.org"
      "https://nix-repo.cachix.org"
    ];

    binaryCachePublicKeys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "nix-repo.cachix.org-1:npOkN9JTf5FvMkTRrvaDd3GvGVO1mBkNU8y6t5UQllk="
    ];

    package = pkgs.nixUnstable;
    useSandbox = true;

    nixPath = [
      "nixpkgs=${flakes.nixpkgs.path}"
    ];

    registry = {
      config = {
        from = {
          id = "pkgs";
          type = "indirect";
        };

        to = {
          path = toString flakes.self.path;
          type = "path";
        };
      };
    };
  };

  nixpkgs = {
    overlays = [
      (
        final: prev: {
          nixos-option = prev.nixos-option.override {
            nix = config.nix.package;
          };

          nix-prefetch-scripts = prev.nix-prefetch-scripts.override {
            nix = config.nix.package;
          };

          vaapiIntel = prev.vaapiIntel.override {
            enableHybridCodec = true;
          };
        }
      )
    ] ++ map
      (p: import (../overlays + "/${p}"))
      (builtins.attrNames (lib.filterAttrs (_: v: v == "regular") (builtins.readDir ../overlays)));

    config = {
      allowUnfree = true;
    };
  };

}
