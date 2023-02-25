{
  systemd.oomd = {
    enable = true;
    enableRootSlice = true;
    enableUserServices = true;
    extraConfig.SwapUsedLimit = "98%";
  };

  zramSwap.enable = true;
}
