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
        hostNames = [
          "github.com"
        ];
        publicKey = "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAq2A7hRGmdnm9tUDbO9IDSwBK6TbQa+PXYPCPy6rbTrTtw7PHkccKrpp0yVhp5HdEIcKr6pLlVDBfOLX9QUsyCOV0wzfjIJNlGEYsdlLJizHhbn2mUjvSAHQqZETYP81eFzLQNnPHt4EVVUh7VfDESU84KezmD5QlWpXLmvU31/yMf+Se8xhHTvKSCZIFImWwoG6mbUoWf9nzpIoaSjB+weqqUUmpaaasXVal72J+UX2B+2RPW3RcT0eOzQgqlJL3RKrTJvdsjE3JEAvGq3lGHSZXy28G3skua2SmVi/w4yCE6gbODqnTWlg7+wC604ydGXA8VJiS5ap43JXiUFFAaQ==";
      };
      gitlab = {
        hostNames = [
          "gitlab.com"
        ];
        publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAfuCHKVTjquxvt6CM6tdG4SLp1Btn/nOeHHE5UOzRdf";
      };
      archcn = {
        hostNames = [
          "build.archlinuxcn.org"
        ];
        publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFiYTB+9JVjER580kp4YTgldaAG9NgjbL+EFh9LD1LIt";
      };
      bwh = {
        hostNames = [ "64.64.228.47" "10.1.11.3" ];
        publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM+UBnDMZ76BSYPGj31tFTZtB42413mmExM/Tqrcy7zc";
      };
      router = {
        hostNames = [
          secrets.ddns-domain
          "10.1.10.1"
        ];
        publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOH3IXHQFOETkbtfUJdfgM9M38GnLjU1ssBahgPJv4wv";
      };
    };
  };
}
