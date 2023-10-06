{ nixosModules, ... }:

{
  imports = [ nixosModules.cloudflare-warp ];
  services = {
    cloudflare-warp = {
      enable = true;
      openFirewall = true;
    };
    v2ray = {
      enable = true;
      config = {
        log = {
          loglevel = "warning";
        };
        inbounds = [
          {
            protocol = "socks";
            tag = "socks";
            listen = "10.1.20.1";
            port = 1080;
          }
        ];
        outbounds = [
          {
            protocol = "socks";
            tag = "proxy";
            settings = {
              servers = [
                {
                  address = "127.0.0.1";
                  port = 1080;
                }
              ];
            };
          }
        ];
      };
    };
  };
}
