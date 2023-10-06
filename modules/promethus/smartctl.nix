{ ... }:

{
  services.prometheus.exporters.smartctl = {
    enable = true;
    port = 29633;
    maxInterval = "30s";
  };
}
