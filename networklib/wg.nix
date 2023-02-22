rec {
  subnetPrefix = "10.1.100";
  prefixLength = 24;

  makeWgPeer' = allowedIPs: machine: {
    wireguardPeerConfig = {
      PublicKey = machine.key;
      AllowedIPs = allowedIPs ++ [ "${subnetPrefix}.${toString machine.id}/32" ];
    } // (if !(builtins.hasAttr "addr" machine) then {} else {
      Endpoint = "${machine.addr}:48927";
    });
  };

  makeWgPeer = makeWgPeer' [];

  makeWgPeers = builtins.map makeWgPeer;

  machines = {
    titan = {
      key = "9+eO4hS6ISzR4nDV+h+f6RvhfEj6i/I0sy7YHgxCfTo=";
      id = 1;
      addr = "titan.poscat.moe";
    };
    nuc = {
      key = "U271RhqD16Nts2tSjWZefoNDTVrTG7Th2oovcl1nM0s=";
      id = 2;
      addr = "nuc.poscat.moe";
    };
    hyperion = {
      key = "W9Z9G1mKBfZajlp/SiJASi5azohl2Uj+TpmiTP96xzU=";
      id = 3;
      addr = "hyperion.poscat.moe";
    };
    bwh = {
      key = "IfZvDkOn1wszaAgzO2/vwxKb3uvTVgJd9VWcj581jyw=";
      id = 4;
      addr = "64.64.228.47";
    };
    mba = {
      key = "pWBN/L65AGXIBwWW2xm3nPBSI76KMBRlb8gnFVCO4Wg=";
      id = 5;
    };
  };

  allMachines = builtins.attrValues (builtins.mapAttrs (k: v: v // { name = k; }) machines);
}
