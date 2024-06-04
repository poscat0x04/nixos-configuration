{ pkgs, ... }:

let
  ip = "${pkgs.iproute2}/bin/ip";
in{
  imports = [ ./wg.nix ];

  # networkd
  systemd.network = {
    # HE tunnel
    netdevs = {
      "he-tunnel" = {
        netdevConfig = {
          Name = "he-ipv6";
          Kind = "sit";
          MTUBytes = "1480";
        };
        tunnelConfig = {
          Local = "64.64.228.47";
          Remote = "66.220.18.42";
        };
      };
    };
    networks = {
      "9-he-tunnel" = {
        name = "he-ipv6";
        address = [ "2001:470:f085::1/48" ];
        dns = [ "2001:4860:4860::8888" ];
        networkConfig = {
          ConfigureWithoutCarrier = true;
          LinkLocalAddressing = "ipv6";
        };
        routes = [
          {
            routeConfig = {
              Gateway = "::";
            };
          }
        ];
      };

      "15-trusted-ethernet" = {
        matchConfig = {
          Name = "ens18";
        };

        DHCP = "yes";
        dns = [ "1.1.1.1" ];

        dhcpV4Config = {
          RouteMetric = 5;
          UseMTU = true;
          UseDNS = false;
        };

        tunnel = [ "he-ipv6" ];
      };
    };
  };

  # firewalls
  networking = {
    forward = true;
    firewall = {
      logRefusedConnections = false;
      trustedInterfaces = [ "wg0" ];
      allowedTCPPorts = [ 443 ];
    };
    fwng = {
      flowtable.devices = [ "ens18" "ens19" ];
      nat = {
        enable = true;
        masquerade = [ "ens18" ];
      };
    };
  };
}
