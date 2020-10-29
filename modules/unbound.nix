{ ... }:

{
  services.unbound = {
    enable = true;
    extraConfig = ''
      forward-zone:
        name: "."
        forward-tls-upstream: yes
        forward-addr: 101.6.6.6@8853
    '';
  };
}
