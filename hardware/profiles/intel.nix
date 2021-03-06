{ pkgs, ... }:

{
  imports = [
    ../cpu/intel
    ../gpu/intel
    ../audio/intel
  ];

  environment.systemPackages = with pkgs; [
    intel-gpu-tools
  ];
}
