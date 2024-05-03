{
  systemd.oomd = {
    enable = true;
    enableRootSlice = true;
    enableUserSlices = true;
    extraConfig.SwapUsedLimit = "98%";
  };

  zramSwap.enable = true;
}
