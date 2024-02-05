{ pkgs, ... }:

{
  imports = [ ./default.nix ];

  boot = {
    consoleLogLevel = 4;
  };

  environment.systemPackages = with pkgs; [
    iptraf-ng
    iftop
    nethogs
    iperf3
  ];
}
