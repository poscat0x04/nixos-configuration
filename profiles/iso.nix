{ modulesPath, pkgs, secrets, ... }:

{
  imports =
    [
      ../hardware/profiles/linux.nix
      ../modules/zsh
      ../modules/ssh.nix
      ../modules/nix.nix
      ../modules/neovim.nix
      "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"
    ];

  console = {
    font = "ter-u28n";
    packages = [ pkgs.terminus_font ];
  };

  environment = {
    memoryAllocator.provider = "libc";

    systemPackages = with pkgs; [
      git
      jq
    ];
  };

  networking = {
    wireless = {
      enable = true;
      userControlled.enable = true;
      networks = secrets.wireless-networks;
    };
  };


  hardware.enableRedistributableFirmware = true;

  isoImage = {
    #compressImage = true;
    includeSystemBuildDependencies = true;

    contents = [
      {
        source = ./..;
        target = "nixos-configuration";
      }
    ];
  };

  nixpkgs.config.allowUnfree = true;
}
