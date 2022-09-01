{ secrets,... }:

{
  programs.ssh = {
    enable = true;
    matchBlocks = {
      bwh = {
        hostname = "64.64.228.47";
        forwardX11 = true;
        forwardX11Trusted = true;
      };
      tbwh = {
        hostname = "10.1.11.3";
        forwardX11 = true;
        forwardX11Trusted = true;
      };
      archcn = {
        hostname = "build.archlinuxcn.org";
        serverAliveInterval = 30;
      };
      router = {
        hostname = "home.poscat.moe";
        forwardX11 = true;
        forwardX11Trusted = true;
      };
      rpi = {
        hostname = "192.168.1.187";
      };
      microserver = {
        hostname = "10.1.10.1";
        forwardX11 = true;
        forwardX11Trusted = true;
      };
    };
  };
}
