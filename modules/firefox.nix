{ pkgs, ... }:

{
  environment = {
    systemPackages = with pkgs; [
      firefox
    ];
    sessionVariables = {
      "MOZ_X11_EGL" = "1";
      "MOZ_USE_XINPUT2" = "1";
    };
  };
}
