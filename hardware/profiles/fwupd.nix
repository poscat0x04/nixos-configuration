{ pkgs, ... }:

{
  services.fwupd.enable = true;

  programs.zsh.interactiveShellInit = ''
    bios-upgrade () {
      ${pkgs.fwupd}/bin/fwupdmgr get-devices
      ${pkgs.fwupd}/bin/fwupdmgr get-updates
      ${pkgs.fwupd}/bin/fwupdmgr update
    }
  '';
}
