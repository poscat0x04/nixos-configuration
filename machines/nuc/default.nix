{...}:

{
  imports = [
    ./hardware-configuration.nix
    ../../profiles/server.nix
    ../../hardware/profiles/uefi.nix
    ../../hardware/cpu/intel
    ./router/dns.nix
    ./router/firewall.nix
    ./router/networks.nix
    ./router/warp.nix
  ];

  nixos.settings = {
    system.user = "poscat";
    machine.hostname = "nuc";
  };

  virtualisation.vmware.guest = {
    enable = true;
    headless = true;
  };

  sops.secrets = {
    wg-private-key = {};
  };

  system.stateVersion = "22.11";
}
