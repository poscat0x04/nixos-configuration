{ modulesPath, pkgs, secrets, ... }:

{
  imports =
    [
      ../modules/ssh.nix
      ../modules/nix.nix
      ../modules/neovim
      "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"
    ];

  console = {
    font = "ter-u28n";
  };

  environment = {
    systemPackages = with pkgs; [
      git
      jq
    ];
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
