{ secrets, ... }:

{
  programs.ssh = {
    setXAuthLocation = true;
    hostKeyAlgorithms = [
      "ssh-ed25519"
      "ssh-rsa"
    ];

    knownHosts = {
      github = {
        extraHostNames = [
          "github.com"
        ];
        publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl";
      };
      gitlab = {
        extraHostNames = [
          "gitlab.com"
        ];
        publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAfuCHKVTjquxvt6CM6tdG4SLp1Btn/nOeHHE5UOzRdf";
      };
      archcn = {
        extraHostNames = [
          "build.archlinuxcn.org"
        ];
        publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFiYTB+9JVjER580kp4YTgldaAG9NgjbL+EFh9LD1LIt";
      };
      bwh = {
        extraHostNames = [ "64.64.228.47" "10.1.11.3" ];
        publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM+UBnDMZ76BSYPGj31tFTZtB42413mmExM/Tqrcy7zc";
      };
      router = {
        extraHostNames = [
          secrets.ddns-domain
          "10.1.10.1"
        ];
        publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOH3IXHQFOETkbtfUJdfgM9M38GnLjU1ssBahgPJv4wv";
      };
    };
  };
}
