{ config, ... }:

let
  cfg = config.nixos.settings.machine.undervolt;
in
{
  imports = [
    ../options/settings/undervolt.nix
  ];

  services.undervolt = with cfg; {
    enable = (core != 0) || (gpu != 0);
    coreOffset = core;
    gpuOffset = gpu;
    uncoreOffset = uncore;
    analogioOffset = analogio;
  };
}
