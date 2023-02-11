{ config, lib, ... }:

let
  cfg = config.networking;
in {
  options.networking.forward = lib.mkEnableOption ''
    Whether to enable IP forwarding
  '';

  config = lib.mkIf cfg.forward {
    boot.kernel.sysctl = {
      "net.ipv4.conf.all.forwarding" = true;
      "net.ipv6.conf.all.forwarding" = true;
    };
  };
}
