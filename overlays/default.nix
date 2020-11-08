self: super: let
  subOverlays = let
    lib = super.stdenv.lib;
  in
    builtins.listToAttrs (
      lib.flatten (
        map
          (
            filename: lib.mapAttrsToList
              (n: v: lib.nameValuePair n v)
              (import (./. + "/pkgs/${filename}") self super)
          )
          (builtins.attrNames (builtins.readDir ./pkgs))
      )
    );
in
  with self.pkgs; subOverlays // {
  }
