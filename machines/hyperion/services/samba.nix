{ pkgs, ... }:

{
  services.samba = {
    enable = true;
    package = pkgs.sambaFull;
    extraConfig = ''
      min protocol = SMB2
      workgroup = WORKGROUP
      server string = smbsrv
      netbios name = smbsrv

      inherit owner = unix only

      hosts allow = 10.1.10. 10.1.20. 10.1.100. localhost
      hosts deny = 0.0.0.0/0

      deadtime = 1200
      use sendfile = yes
      aio read size = 1
      aio write size = 1

      vfs objects = fruit streams_xattr
      fruit:metadata = stream
      fruit:model = MacSamba
      fruit:veto_appledouble = no
      fruit:posix_rename = yes
      fruit:zero_file_id = yes
      fruit:wipe_intentionally_left_blank_rfork = yes
      fruit:delete_empty_adfiles = yes

      load printers = no
      printing = cups
      printcap name = cups
    '';
    shares = {
      poscat = {
        path = "/share/poscat";
        "valid users" = "poscat";
        "guest ok" = "no";
        public = "no";
        writable = "yes";
        printable = "no";
        browsable = "yes";
      };
      tm_share = {
        path = "/share/timemachine";
        "valid users" = "poscat";
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

  environment.systemPackages = [ pkgs.sambaFull ];
}
