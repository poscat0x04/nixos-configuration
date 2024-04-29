{ ... }:

{
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
          TTL = 255;
        };
      };
    };
    networks = {
      "9-he-tunnel" = {
        name = "he-ipv6";
        address = [ "2001:470:c:b75::2/64" ];
        gateway = [ "2001:470:c:b75::1" ];
        dns = [ "2001:4860:4860::8888" ];
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
      flowtable.devices = [ "ens18" "ens19" "he-ipv6" ];
      nat = {
        enable = true;
        masquerade = [ "ens18" ];
      };
      nat66= {
        enable = true;
        masquerade = [ "he-ipv6" ];
      };
    };
  };
}
