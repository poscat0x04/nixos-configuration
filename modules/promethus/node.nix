{ ... }:

{
  services.prometheus.exporters.node = {
    enable = true;
    port = 29100;
    enabledCollectors = [
      "systemd"
      "logind"
      "cgroups"
    ];
  };
}
