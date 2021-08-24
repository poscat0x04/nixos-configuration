{ pkgs, ... }:

{
  imports = [
    ./default.nix
  ];

  boot = {
    consoleLogLevel = 4;

    kernelParams = [
      # Trust RDRAND
      "random.trust_cpu=on"
      # Turn off CPU mitigations
      "mitigations=off"
    ];
  };

  environment.systemPackages = with pkgs; [
    traceroute
    iptraf-ng
    speedtest-cli
    iftop
    nethogs
  ];
}
