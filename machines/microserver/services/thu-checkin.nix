{ secrets, nixosModules, ... }:

{
  imports = [ nixosModules.thu-checkin ];

  services.thu-checkin = {
    enable = true;
    config = {
      USERNAME = secrets.thu-username;
      PASSWORD = secrets.thu-password;
      PROVINCE = "340000";
      CITY = "340100";
      COUNTRY = "340104";
      IS_INSCHOOL = "4";
    };
  };
}
