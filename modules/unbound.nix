{ ... }:

{
  services.unbound = {
    enable = true;
    settings = {
      forward-zone = [
        {
          name = ".";
          forward-addr = "101.6.6.6@8853";
          forward-tls-upstream = true;
        }
      ];
    };
  };
}
