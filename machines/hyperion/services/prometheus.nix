{ config, ... }:

{
  services.prometheus = {
    enable = true;
    stateDir = "prometheus";
    scrapeConfigs = [
      {
        job_name = "hyperion";
        static_configs = [
          {
            targets = [
              "127.0.0.1:${toString config.services.prometheus.exporters.node.port}"
              "127.0.0.1:${toString config.services.prometheus.exporters.smartctl.port}"
            ];
          }
        ];
      }
    ];
  };
}
