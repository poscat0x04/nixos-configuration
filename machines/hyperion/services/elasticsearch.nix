{ pkgs, ... }:

let
  es = pkgs.elasticsearch.override { jre_headless = pkgs.jre_headless; };
in {
  services.elasticsearch = {
    enable = true;
    package = es;
    port = 9201;
    extraJavaOptions = [ "-XX:+UseTransparentHugePages" ];
    extraConf = ''
      xpack.security.enabled: false
    '';
  };
}
