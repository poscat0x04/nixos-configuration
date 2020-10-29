servers:
{
  inbounds = [
    {
      port = 1080;
      listen = "127.0.0.1";
      protocol = "socks";
    }
    {
      port = 5768;
      listen = "127.0.0.1";
      protocol = "dokodemo-door";
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
  routing = {
    domainStrategy = "IPIfNonMatch";
    rules = [
      {
        type = "field";
        outboundTag = "direct";
        protocol = [
          "bittorrent"
        ];
      }
      {
        type = "field";
        domain = [
          "cn"
          "category-ads"
        ];
        ip = [
          "geoip:cn"
          "geoip:private"
        ];
        outboundTag = "blocked";
      }
      {
        type = "field";
        network = "tcp, udp";
        outboundTag = "bwh";
      }
    ];
  };
}
