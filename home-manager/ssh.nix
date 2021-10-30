{ secrets,... }:

{
  programs.ssh = {
    enable = true;
    matchBlocks = {
      bwh = {
        hostname = "64.64.228.47";
        forwardX11 = true;
        forwardX11Trusted = true;
        remoteForwards = [
          {
            bind.address = "/run/user/1000/gnupg/S.gpg-agent";
            host.address = "/run/user/1000/gnupg/S.gpg-agent";
          }
          {
            bind.address = "/run/user/1000/gnupg/S.gpg-agent.ssh";
            host.address = "/run/user/1000/gnupg/S.gpg-agent.ssh";
          }
        ];
      };
      tbwh = {
        hostname = "10.1.11.3";
        forwardX11 = true;
        forwardX11Trusted = true;
        remoteForwards = [
          {
            bind.address = "/run/user/1000/gnupg/S.gpg-agent";
            host.address = "/run/user/1000/gnupg/S.gpg-agent";
          }
          {
            bind.address = "/run/user/1000/gnupg/S.gpg-agent.ssh";
            host.address = "/run/user/1000/gnupg/S.gpg-agent.ssh";
          }
        ];
      };
      archcn = {
        hostname = "build.archlinuxcn.org";
        serverAliveInterval = 30;
      };
      router = {
        hostname = "home.poscat.moe";
        forwardX11 = true;
        forwardX11Trusted = true;
        remoteForwards = [
          {
            bind.address = "/run/user/1000/gnupg/S.gpg-agent";
            host.address = "/run/user/1000/gnupg/S.gpg-agent";
          }
          {
            bind.address = "/run/user/1000/gnupg/S.gpg-agent.ssh";
            host.address = "/run/user/1000/gnupg/S.gpg-agent.ssh";
          }
        ];
      };
      rpi = {
        hostname = "192.168.1.187";
      };
      microserver = {
        hostname = "10.1.10.1";
        forwardX11 = true;
        forwardX11Trusted = true;
        remoteForwards = [
          {
            bind.address = "/run/user/1000/gnupg/S.gpg-agent";
            host.address = "/run/user/1000/gnupg/S.gpg-agent";
          }
          {
            bind.address = "/run/user/1000/gnupg/S.gpg-agent.ssh";
            host.address = "/run/user/1000/gnupg/S.gpg-agent.ssh";
          }
        ];
      };
    };
  };
}
