{ secrets, ... }:

let
  makeKnownHosts = s: builtins.mapAttrs (_: v: {publicKey = v;}) s;
in {
  programs.ssh = {
    setXAuthLocation = true;
    hostKeyAlgorithms = [
      "ssh-ed25519"
      "ssh-rsa"
    ];

    knownHosts = makeKnownHosts {
      "github.com" = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl";
      "gitlab.com" = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAfuCHKVTjquxvt6CM6tdG4SLp1Btn/nOeHHE5UOzRdf";
      "build.archlinuxcn.org" = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFiYTB+9JVjER580kp4YTgldaAG9NgjbL+EFh9LD1LIt";
      "64.64.228.47" = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM+UBnDMZ76BSYPGj31tFTZtB42413mmExM/Tqrcy7zc";
      "nuc.poscat.moe" = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIyIaZR8gh7z3ZKYJJunVfeiFButXiCBp5Mciv2h1Ayy";
      "titan.poscat.moe" = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBFu4YEa65Onqx3o4GeGrqIyc+S2OEPgBQSdBtt1HDAR";
      "hyperion.poscat.moe" = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOxuqPlqGGla89vfFBn9oOMK1trR0mjXE9KeWvVyK7cB";
    };
  };
}
