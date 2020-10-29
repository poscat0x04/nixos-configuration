{ ... }:

{
  services.thermald = {
    enable = true;
    configFile = ./thermald-conf.xml;
  };
}
