{...}:

{
  imports = [
    ./hardware-configuration.nix
    ../../profiles/server.nix
    ../../hardware/profiles/uefi.nix
    ../../hardware/cpu/intel
    ../../modules/unbound.nix
    #./router/dns.nix
    #./router/firewall.nix
    #./router/networks.nix
  ];

  nixos.settings = {
    system.user = "poscat";
    machine.hostname = "titan";
  };

  # vmware tools
  virtualisation.vmware.guest = {
    enable = true;
    headless = true;
  };

  system.stateVersion = "22.11";
}
