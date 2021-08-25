{ lib, ... }:

{
  services.v2ray.overlay = cfg: lib.recursiveUpdate cfg {
    inbounds = cfg.inbounds ++ lib.singleton {
      protocol = "mtproto";
      tag = "mtproto-in";
      listen = "0.0.0.0";
      port = 2285;
      settings = {
        users = [
          {
            secret = "5dc9abf42c456d52b7af02f4b124edba";
          }
        ];
      };
    };
    outbounds = cfg.outbounds ++ lib.singleton {
      protocol = "mtproto";
      tag = "mtproto-out";
      proxySettings = {
        tag = "proxy";
      };
    };
    routing.rules = (lib.singleton {
      type = "field";
      inboundTag = [ "mtproto-in" ];
      outboundTag = "mtproto-out";
    }) ++ cfg.routing.rules;
  };
}
