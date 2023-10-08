{ ... }:

{
  services.prometheus.exporters.smokeping = {
    enable = true;
    port = 29374;
    hosts = [
      "8.8.8.8"
      "101.101.101.101"
      "1.1.1.1"
      "162.159.193.1"
      "162.159.192.24"
      "162.159.192.204"
      "2606:4700:d0::a29f:c111"
    ];
  };
  systemd.services.prometheus-smokeping-exporter.serviceConfig.Slice = "system-noproxy.slice";
}
