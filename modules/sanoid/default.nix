{ lib, pkgs,  ... }:

{
  services.sanoid = {
    enable = true;
    templates = {
      storage = {
        autoprune = true;
        autosnap = true;
        daily = 60;
        hourly = 72;
        monthly = 12;
        yearly = 3;
      };
    };
    datasets = {
      "rpool/root" = {
        useTemplate = [ "storage" ];
      };
      "rpool/home" = {
        useTemplate = [ "storage" ];
      };
    };
  };

  environment.systemPackages = lib.mkAfter [ pkgs.sanoid ];
}
