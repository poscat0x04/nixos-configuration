{ ... }:

{
  imports = [
    ./fwupd.nix
  ];
  services.thinkfan = {
    enable = true;
    smartSupport = true;
  };
}
