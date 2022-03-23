{ secrets, nixosModules, ... }:

{
  imports = [ nixosModules.thu-checkin ];

  services.thu-checkin = {
    enable = true;
    config = {
      USERNAME = secrets.thu-username;
      PASSWORD = secrets.thu-password;
      JUZHUDI = "合肥市内校外";
      REASON = "3";
      RETURN_COLLEGE = "东校区";
    };
  };
}
