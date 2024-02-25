rec {
  mkIf = b: a: {
    _type = "if";
    condition = b;
    content = a;
  };

  mkNull = a: mkIf (a != null) a;

  makeRouteConfig = {metric ? null, table}: ip: {
    routeConfig = {
      Destination = ip;
      Table = table;
      Metric = mkNull metric;
    };
  };

  # This should cover all possible genshin (Asian) server IPs
  alibaba-tokyo-ip = [
    "47.74.0.0/18"
    "47.74.32.0/19"
    "47.91.0.0/19"
    "47.91.16.0/20"
    "47.245.0.0/18"
    "47.245.32.0/19"
    "47.245.48.0/20"
    "8.209.192.0/18"
    "8.209.224.0/19"
    "8.211.128.0/18"
  ];

  # additional IP ranges that should not be proxied
  more-direct = [
    # quad101 dns
    "101.101.101.101"
    "101.102.103.104"
    # dns666
    "101.6.6.6"
    # bwh
    "64.64.228.47"
    # bar
    "154.26.155.238"
    "135.125.190.148"
    "135.125.232.13"
    "176.57.150.243"
    "45.85.250.178"
    "153.92.127.27"
    "135.148.139.38"
    "192.210.162.137"
    "207.244.249.133"
    "144.126.147.151"
    "84.236.36.116"
    "213.197.95.10"
  ];

  direct-ips = alibaba-tokyo-ip ++ more-direct;

  makeDirectRoutes = { metric ? null }:
    map (makeRouteConfig { metric = metric; table = "others-direct"; }) direct-ips;

  makeWANConfig = {ifname}: {
    matchConfig.Name = ifname;

    # Disable IPv6 Link Local Addressing
    networkConfig.LinkLocalAddressing = "no";

    # Do not require for online
    linkConfig = {
      RequiredForOnline = false;
    };
  };

  makeLanConfig = {addr, ifname}: {
    matchConfig.Name = ifname;

    addresses = [
      {
        addressConfig = {
          Address = "${addr}/24";
        };
      }
    ];

    networkConfig = {
      # IPv6 RA
      DHCPPrefixDelegation = true;
      IPv6SendRA = true;
      IPv6AcceptRA = false;

      # DHCPv4
      DHCPServer = true;
    };

    # DHCPv4 server config
    dhcpServerConfig = {
      BindToInterface = true;
      PoolOffset = 50;
      DefaultLeaseTimeSec = "1d";
      MaxLeaseTimeSec = "7d";
      DNS = addr;
    };

    # Do not require for online
    linkConfig = {
      RequiredForOnline = false;
    };
  };

  makeTrustedDHCPConfig = {metric}: {
    # Enables both DHCPv4 and DHCPv6
    DHCP = "yes";

    dhcpV4Config = {
      RouteMetric = metric;
      UseMTU = true;
    };

    dhcpV6Config = {
      RouteMetric = metric;
    };

    ipv6AcceptRAConfig = {
      RouteMetric = metric;
    };

    networkConfig = {
      IPv6AcceptRA = true;
      IPv6PrivacyExtensions = "prefer-public";
    };
  };

  makeUntrustedDHCPConfig = {metric}: {
    # Use unbound to resolve names
    dns = [ "127.0.0.1:53" ];

    # Enables both DHCPv4 and DHCPv6
    DHCP = "yes";

    dhcpV4Config = {
      RouteMetric = metric;
      UseDNS = false;
      UseNTP = false;
      UseMTU = true;
    };

    dhcpV6Config = {
      RouteMetric = metric;
      UseDNS = false;
      UseNTP = false;
    };

    ipv6AcceptRAConfig = {
      RouteMetric = metric;
    };

    networkConfig = {
      IPv6AcceptRA = true;
      IPv6PrivacyExtensions = "yes";
    };
  };

  makePPPConfig = {metric}: {
    matchConfig.Type = "ppp";

    # Use DHCPv6 to acquire prefix delegation
    DHCP = "ipv6";
    dhcpV6Config = {
      UseDelegatedPrefix = true;
      RouteMetric = metric;
      UseDNS = false;
      UseNTP = false;
    };

    # Use unbound to resolve names
    dns = [ "127.0.0.1:53" ];

    # Use IPv6 RA to acquire IPv6 address
    networkConfig = {
      IPv6AcceptRA = true;
      IPv6PrivacyExtensions = "no";
      KeepConfiguration = "static";
    };
    ipv6AcceptRAConfig = {
      DHCPv6Client = "always";
      UseDNS = false;
    };

    # Add routes
    routes = [
      {
        routeConfig = {
          Destination = "0.0.0.0/0";
          Scope = "global";
          Metric = metric;
        };
      }
      {
        routeConfig = {
          Destination = "0.0.0.0/0";
          Table = "symmetry";
        };
      }
    ] ++ makeDirectRoutes { metric = metric; };
  };

  wireguard = import ./wg.nix;
}
