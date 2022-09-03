{ secrets,... }:

{
  programs.ssh = {
    enable = true;
    extraConfig = ''
      AddKeysToAgent yes
    '';
    matchBlocks = {
      bwh = {
        hostname = "64.64.228.47";
        forwardAgent = true;
        forwardX11 = true;
        forwardX11Trusted = true;
      };
      tbwh = {
        hostname = "10.1.11.3";
        forwardAgent = true;
        forwardX11 = true;
        forwardX11Trusted = true;
      };
      router = {
        hostname = "home.poscat.moe";
        forwardAgent = true;
        forwardX11 = true;
        forwardX11Trusted = true;
      };
      microserver = {
        hostname = "10.1.10.1";
        forwardAgent = true;
        forwardX11 = true;
        forwardX11Trusted = true;
      };
    };
  };
}
