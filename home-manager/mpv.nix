{ ... }:

{
  programs.mpv = {
    enable = true;
    bindings = {
      UP = "add volume +2";
      DOWN = "add volume -2";
    };
    config = {
      hwdec = "vaapi";
      profile = "gpu-hq";
    };
  };
}
