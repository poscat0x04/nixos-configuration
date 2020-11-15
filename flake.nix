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
    nur.url = github:nix-community/NUR;
  };


  outputs = { self, nixpkgs, home-manager, nix-secrets, nur, nix-repo, hath-nix, ... }@inputs: with nixpkgs.lib;
    let
      baseSystem =
        { system ? "x86_64-linux", modules ? [], overlay ? true }@config:
          nixosSystem {
            inherit system;
            specialArgs = rec {
              secrets = nix-secrets;
              flakes = genAttrs (builtins.attrNames inputs)
                (flake:
                  (if (inputs.${flake} ? packages && inputs.${flake}.packages ? ${system})
                    then inputs.${flake}.packages.${system}
                    else {})
                  // {
                    path = inputs.${flake};
                    nixosModules = inputs.${flake}.nixosModules or {};
                  });

              nixosModules = foldl recursiveUpdate {} (map (flake: flake.nixosModules or {}) (attrValues flakes));
            };

            modules =
              (optional overlay { nixpkgs.overlays = mkBefore [ nix-repo.overlay hath-nix.overlay nur.overlay ]; })
              ++ 
                [
                  {
                    _module.args.system = system;
                  }
                ]
              ++ config.modules;
          };
    in
      { nixosConfigurations = {
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
      };
}
