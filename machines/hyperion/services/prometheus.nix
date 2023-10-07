{ config, ... }:

{
  services.prometheus = {
    enable = true;
    stateDir = "prometheus";
    enableReload = true;
    globalConfig = {
      scrape_interval = "30s";
      evaluation_interval = "30s";
    };
    scrapeConfigs = [
      {
        job_name = "hyperion";
        static_configs = [
          {
            targets = [
              "127.0.0.1:${toString config.services.prometheus.exporters.node.port}"
              "127.0.0.1:${toString config.services.prometheus.exporters.smartctl.port}"
            ];
            labels = {
              hostname = "hyperion";
            };
          }
        ];
      }
      {
        job_name = "nuc";
        static_configs = [
          {
            targets = [
              "10.1.20.1:${toString config.services.prometheus.exporters.node.port}"
            ];
            labels = {
              hostname = "nuc";
            };
          }
        ];
      }
      {
        job_name = "dione";
        static_configs = [
          {
            targets = [
              "10.1.10.4:9100"
            ];
            labels = {
              hostname = "nuc";
            };
          }
        ];
      }
    ];
  };
}
