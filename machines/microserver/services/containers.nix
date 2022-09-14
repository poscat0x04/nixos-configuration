{ ... }:

{
  systemd.nspawn = {
    arch = {
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
    "systemd-nspawn@arch.service"
  ];
}
