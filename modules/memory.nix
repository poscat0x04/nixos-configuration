{
  systemd.oomd = {
    enable = true;
    enableRootSlice = true;
    enableUserSlices = true;
    extraConfig.SwapUsedLimit = "98%";
  };

  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 100;
  };
  boot.kernel.sysctl = {
    "vm.swappiness" = 180;
    "vm.watermark_boost_factor" = 0;
    "vm.watermark_scale_factor" = 125;
    "vm.page-cluster" = 0;
  };
}
