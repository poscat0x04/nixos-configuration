{ pkgs, ... }:

{
  imports = [
    ./default.nix
    ../modules/sops-nix.nix
  ];

  boot = {
    consoleLogLevel = 4;
  };

  environment.systemPackages = with pkgs; [
    traceroute
    iptraf-ng
    speedtest-cli
    iftop
    nethogs
  ];
}
