{ secrets,... }:

let
  mkHost = host: {
    hostname = host;
    forwardX11 = true;
    forwardX11Trusted = true;
  };
in{
  programs.ssh = {
    enable = true;
    extraConfig = ''
      AddKeysToAgent yes
    '';
    forwardAgent = true;
    matchBlocks = {
      bwh = mkHost "64.64.228.47";
      titan = mkHost "titan.poscat.moe";
      hyperion = mkHost "hyperion.poscat.moe";
      nuc = mkHost "nuc.poscat.moe";
    };
  };
}
