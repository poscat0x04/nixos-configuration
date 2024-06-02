{ pkgs, ... }:

let
  ip = "${pkgs.iproute2}/bin/ip";
in{
  imports = [ ./wg.nix ];

  # networkd
  systemd.network = {
    # HE tunnel
    /*
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
    */
    networks = {
      "9-he-tunnel" = {
        name = "he-ipv6";
        linkConfig.Unmanaged = true;
        /*
        address = [ "2001:470:f085::1/64" ];
        gateway = [ "2001:470:c:b75::1" ];
        dns = [ "2001:4860:4860::8888" ];
        networkConfig = {
          ConfigureWithoutCarrier = true;
          LinkLocalAddressing = "ipv6";
        };
        */
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
  systemd.services.he-ipv6 = {
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    path = [ pkgs.iproute2 ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = [
        "${ip} tunnel add he-ipv6 mode sit remote 66.220.18.42 local 64.64.228.47"
        "${ip} link set he-ipv6 up mtu 1480"
        "${ip} addr add 2001:470:f085::/48 dev he-ipv6"
        "${ip} -6 route add ::/0 dev he-ipv6"
      ];
      ExecStop = [
        "${ip} -6 route del ::/0 dev he-ipv6"
        "${ip} link set he-ipv6 down"
        "${ip} tunnel del he-ipv6"
      ];
      RemainAfterExit = true;
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
