servers:
{
  inbounds = [
    {
      port = 1080;
      listen = "127.0.0.1";
      protocol = "socks";
      sniffing = {
        enabled = true;
      };
    }
    {
      port = 5768;
      listen = "127.0.0.1";
      protocol = "dokodemo-door";
      sniffing = {
        enabled = true;
      };
    }
  ];
  outbounds = servers ++ [
    {
      protocol = "freedom";
      settings = {};
      tag = "direct";
    }
    {
      protocol = "blackhole";
      settings = {};
      tag = "blocked";
    }
  ];
  log = {
    loglevel = "warning";
  };
  dns = {
    servers = [
      "127.0.0.53"
    ];
  };
  routing = {
    domainStrategy = "IPIfNonMatch";
    domainMatcher = "mph";
    rules = [
      {
        type = "field";
        protocol = [
          "bittorrent"
        ];
        outboundTag = "direct";
      }
      {
        type = "field";
        domain = [
          "geolocation-cn"
        ];
        outboundTag = "direct";
      }
      {
        type = "field";
        domain = [
          "category-ads"
        ];
        outboundTag = "blocked";
      }
      {
        type = "field";
        ip = [
          "geoip:private"
        ];
        outboundTag = "blocked";
      }
      {
        type = "field";
        ip = [
          "geoip:cn"
        ];
        outboundTag = "direct";
      }
      {
        type = "field";
        network = "tcp, udp";
        outboundTag = "bwh";
      }
    ];
  };
}
