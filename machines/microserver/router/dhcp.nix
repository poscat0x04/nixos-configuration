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
              { pool = "10.1.10.1 - 10.1.10.254"; }
            ];
          }
        ];
      };
    };
  };
}
