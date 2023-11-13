{ config, ... }:

let
  lh = "127.0.0.1";
  np = toString config.services.prometheus.exporters.node.port;
  sp = toString config.services.prometheus.exporters.smartctl.port;
  pp = toString config.services.prometheus.exporters.smokeping.port;
  mkcfg = name: target: { targets = [ target ]; labels.exporter_name = name; };
  mkhost = ip: port: "${ip}:${port}";
in {
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
          (mkcfg "node" (mkhost lh np))
          (mkcfg "smartctl" (mkhost lh sp))
          (mkcfg "minecraft" (mkhost lh "25585"))
          (mkcfg "ping" (mkhost lh pp))
        ];
      }
      {
        job_name = "nuc";
        static_configs = [
          (mkcfg "node" (mkhost "10.1.20.1" np))
          (mkcfg "ping" (mkhost "10.1.20.1" pp))
        ];
      }
      {
        job_name = "dione";
        static_configs = [ (mkcfg "node" "10.1.10.4:9100") ];
      }
      {
        job_name = "titan";
        static_configs = [ (mkcfg "node" (mkhost "10.1.10.1" np)) ];
      }
    ];
  };
}
