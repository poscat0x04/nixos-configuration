{ secrets, flakes, pkgs, config, lib, ... }:

let
  flakesEmpty = pkgs.writeText "flakes-empty.json" (builtins.toJSON { flakes = []; version = 2; });
  cfg = config.nix;
in

{
  options.nix = {
    useMirror = lib.mkOption {
      type = lib.types.bool;
      default = true;
    };
    mirrorUrl = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [
        "https://mirror.sjtu.edu.cn/nix-channels/store"
        "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
      ];
    };
  };
  config = {
    nix = {
      extraOptions = ''
        experimental-features = flakes nix-command
        access-tokens = github.com=${secrets.github-token}
        flake-registry = ${flakesEmpty}
      '';

      package = pkgs.nixUnstable;

      settings = {
        sandbox = true;

        trusted-users = [ "root" "@wheel" ];

        substituters = lib.optionals cfg.useMirror cfg.mirrorUrl ++ [
          "https://nix-community.cachix.org"
          "https://nix-repo.cachix.org"
        ];

        trusted-public-keys = [
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          "nix-repo.cachix.org-1:npOkN9JTf5FvMkTRrvaDd3GvGVO1mBkNU8y6t5UQllk="
        ];
      };

      nixPath = [
          "nixpkgs=${flakes.nixpkgs.path}"
      ];

      registry = {
        nixpkgs = lib.mkForce {
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
  };
}
