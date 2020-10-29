{ pkgs, lib, ... }:

{
  boot.kernelParams = [
    # Enable frame buffer compression
    "i915.enable_fbc=1"
    # Enable fastboot
    "i915.fastboot=1"
    # Enable GuC / HuC firmware loading
    "i915.enable_guc=2"
  ];

  environment = {
    systemPackages = with pkgs; [ libva-utils ];
  };

  hardware.opengl = {
    extraPackages = with pkgs; [ vaapiIntel intel-ocl intel-media-driver intel-compute-runtime ];
  };

  services.xserver = {
    useGlamor = true;
    videoDrivers = lib.mkDefault [ "modesetting" ];
  };
}
