{ ... }:

{
  systemd.nspawn = {
    fedora-dev = {
      execConfig = {
        Boot = true;
        PrivateUsers = "pick";
      };
      networkConfig = {
        Private = true;
        VirtualEthernet = false;
        VirtualEthernetExtra = "veth-fedora:host0";
      };
    };
    arch-dev = {
      execConfig = {
        Boot = true;
        PrivateUsers = "pick";
      };
      networkConfig = {
        Private = true;
        VirtualEthernet = false;
        VirtualEthernetExtra = "veth-arch:host0";
      };
    };
  };

  systemd.targets.machines.wants =[
    "systemd-nspawn@fedora-dev.service"
    "systemd-nspawn@arch-dev.service"
  ];
}
