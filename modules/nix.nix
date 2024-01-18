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

      package = pkgs.nixFlakes;

      settings = {
        sandbox = true;

        trusted-users = [ "root" "@wheel" ];

        substituters = lib.optionals cfg.useMirror cfg.mirrorUrl ++ [ "https://cache.poscat.moe:8443/dev/" ];

        trusted-public-keys = [ "dev:ZPWlFkQ5XmcK3N/nxuKC+eqtPm+S82vTUYEU18LoSbI" ];
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

    systemd.services.nix-daemon = {
      environment.TMPDIR = "/run/nix-daemon";
      serviceConfig.RuntimeDirectory = "nix-daemon";
    };
  };
}
