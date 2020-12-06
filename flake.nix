{
  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixos-unstable;
    home-manager = {
      url = github:nix-community/home-manager;
      inputs.nixpkgs.follows = "/nixpkgs";
    };
    nix-repo = {
      url = github:poscat0x04/nix-repo;
      inputs.nixpkgs.follows = "/nixpkgs";
    };
    nix-secrets = {
      url = github:poscat0x04/nix-secrets;
      inputs.nixpkgs.follows = "/nixpkgs";
    };
    hath-nix.url = github:poscat0x04/hath-nix;
    nixos-emacs.url = github:nix-community/emacs-overlay;
    flake-utils.url = github:poscat0x04/flake-utils;
  };


  outputs =
    { self
    , nixpkgs
    , home-manager
    , nix-secrets
    , nix-repo
    , hath-nix
    , nixos-emacs
    , flake-utils
    , ...
    }@inputs: with flake-utils; with nixpkgs.lib;
    let
      overlays = map (f: f.overlay) [ nix-repo hath-nix nixos-emacs ];
      baseSystem =
        { system ? "x86_64-linux", modules ? [], overlay ? true }@config:
          nixosSystem {
            inherit system;
            specialArgs = rec {
              secrets = nix-secrets;
              flakes = genAttrs (builtins.attrNames inputs)
                (
                  flake:
                    (
                      if (inputs.${flake} ? packages && inputs.${flake}.packages ? ${system})
                      then inputs.${flake}.packages.${system}
                      else {}
                    )
                    // {
                      path = inputs.${flake};
                      nixosModules = inputs.${flake}.nixosModules or {};
                    }
                );

              nixosModules = foldl recursiveUpdate {} (map (flake: flake.nixosModules or {}) (attrValues flakes));
            };

            modules =
              (optional overlay { nixpkgs.overlays = mkBefore overlays; })
              ++ [
                {
                  _module.args.system = system;
                }
              ]
              ++ config.modules;
          };
    in
      {
        nixosConfigurations = {
          c940 = baseSystem rec {
            modules = [
              ./machines/c940
            ];
          };
          t460p = baseSystem {
            modules = [
              ./machines/t460p
            ];
          };
        };

      } // eachDefaultSystem (
        system: {
          legacyPackages = import nixpkgs { inherit system overlays; };
        }
      );
}
