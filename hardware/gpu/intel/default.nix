{ config, pkgs, lib, ... }:

let
  ihd = config.nixos.settings.machine.ihd;
in

{
  config = {
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
      extraPackages = with pkgs; [
        intel-ocl
        intel-compute-runtime
      ] ++ (
        if ihd
        then lib.singleton intel-media-driver
        else lib.singleton vaapiIntel
      );
    };

    services.xserver = {
      useGlamor = true;
      videoDrivers = lib.mkDefault [ "modesetting" ];
    };

    environment.sessionVariables."LIBVA_DRIVER_NAME" =
      if ihd
      then "iHD"
      else "i965";
  };

  options.nixos.settings.machine.ihd = with lib; mkOption {
    type = types.bool;
    default = false;
    description = ''
      Whether the GPU is HD Graphics.
    '';
  };
}
