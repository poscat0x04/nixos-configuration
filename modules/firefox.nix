{ pkgs, ... }:

{
  environment = {
    systemPackages = with pkgs; [
      firefox
    ];
    sessionVariables = {
      "MOZ_X11_EGL" = "1";
      "MOZ_USE_XINPUT2" = "1";
      "MOZ_DISABLE_RDD_SANDBOX" = "1";
    };
  };
}
