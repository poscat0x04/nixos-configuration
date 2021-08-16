{ ... }:

{
  services.kea = {
    dhcp4 = {
      enable = true;
      settings = {
        interfaces-config = {
          interfaces = [
            "br-lan"
          ];
        };
        rebind-timer = 86400;
        renew-timer = 43200;
        valid-lifetime = 604800;
        lease-database = {
          name = "/var/lib/kea/dhcp4.leases";
          persist = true;
          type = "memfile";
        };
        subnet4 = [
          {
            subnet = "10.1.10.0/24";
            pools = [
              { pool = "10.1.10.2 - 10.1.10.254"; }
            ];
            option-data = [
              {
                name = "domain-name-servers";
                code = 6;
                data = "10.1.10.1";
              }
              {
                name = "routers";
                code = 3;
                data = "10.1.10.1";
              }
              {
                name = "interface-mtu";
                code = 26;
                data = "1492";
              }
            ];
          }
        ];
      };
    };
  };
}
