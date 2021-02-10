{ ... }:

{
  services.xserver.libinput = {
    enable = true;
    touchpad = {
      naturalScrolling = true;
      disableWhileTyping = true;
    };
  };
}
