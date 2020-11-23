{ secrets, flakes, pkgs, config, lib, ... }:

{
  nix = {
    extraOptions = ''
      experimental-features = flakes nix-command
      access-tokens = github.com=${secrets.credentials.github}
    '';

    binaryCaches = [
      "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
      "https://hydra.iohk.io"
    ];

    binaryCachePublicKeys = [
      "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="
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

          nix-index = prev.nix-index.override {
            nix = config.nix.package;
          };

          nix-prefetch-scripts = prev.nix-prefetch-scripts.override {
            nix = config.nix.package;
          };
        }
      )
    ] ++ map
      (p: import (../overlays + "/${p}"))
      (builtins.attrNames (lib.filterAttrs (_: v: v == "regular") (builtins.readDir ../overlays)));

    config = {
      allowUnfree = true;
      packageOverrides = pkgs: {
        vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
      };
    };
  };

}
