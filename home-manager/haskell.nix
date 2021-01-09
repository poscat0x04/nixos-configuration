{ pkgs, ... }:

let
  hackage-password = pkgs.writeShellScript "hackage-password" ''
    echo ".i3\rT38AtjR((Y8}i"
  '';
in

{
  home.file.".cabal/config".text = ''
    repository hackage.haskell.org
      url: http://hackage.haskell.org/
      -- secure: True
      -- root-keys:
      -- key-threshold: 3

    world-file: /home/poscat/.cabal/world
    extra-prog-path: /home/poscat/.cabal/bin
    build-summary: /home/poscat/.cabal/logs/build.log
    remote-build-reporting: anonymous
    jobs: $ncpus
    installdir: /home/poscat/.cabal/bin
    username: Poscat
    password-command: ${hackage-password}
  '';

  home.file.".ghc/ghci.conf".text = ''
    :set prompt "\ESC[1;35m\x03BB> \ESC[m"
    :set prompt-cont "\ESC[1;35m > \ESC[m"
  '';
}
