{ ... }:

{
  networking = {
    firewall.enable = false;
    nftables = {
      enable = true;
      ruleset = "";
    };
  };
}
