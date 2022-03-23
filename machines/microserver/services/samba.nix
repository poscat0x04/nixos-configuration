{ pkgs, ... }:

{
  services.samba = {
    enable = true;
    package = pkgs.sambaFull;
    extraConfig = ''
      workgroup = WORKGROUP
      server string = smbsrv
      netbios name = smbsrv

      inherit owner = unix only

      ;hosts allow = 10.1.11. localhost
      ;hosts deny = 0.0.0.0/0

      deadtime = 1200
      use sendfile = yes
      aio read size = 1
      aio write size = 1

      load printers = no
      printing = cups
      printcap name = cups
    '';
    shares = {
      poscat = {
        path = "/shares/poscat";
        "valid users" = "poscat";
        "force user" = "poscat";
        "force group" = "users";
        "guest ok" = "no";
        public = "no";
        writable = "yes";
        printable = "no";
        browsable = "yes";
      };
      tm_share = {
        path = "/shares/timemachine";
        "valid users" = "@timemachine";
        "guest ok" = "no";
        public = "no";
        writable = "yes";
        browsable = "no";
        "fruit:appl" = "yes";
        "fruit:timemachine" = "yes";
        "vfs object" = "catia fruit streams_xattr";
      };
    };
  };

  environment.systemPackages = with pkgs; [ sambaFull ];
}
