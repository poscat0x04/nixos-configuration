{ ... }:

{
  systemd.network = {
    netdevs = {
      br-lan = {
        netdevConfig = {
          Name = "br-lan";
          Kind = "bridge";
        };
      };
      dummy0 = {
        netdevConfig = {
          Name = "dummy0";
          Kind = "dummy";
        };
      };
    };
    networks = {
      "11-br-lan" = {
        matchConfig.Name = "br-lan";
        addresses = [
          {
            addressConfig = {
              Address = "10.1.10.1/24";
            };
          }
        ];
      };
      "12-bind-br" = {
        matchConfig.Name = "eno3 eno4 dummy0";
        networkConfig = {
          Bridge = "br-lan";
        };
      };
    };
  };
}
