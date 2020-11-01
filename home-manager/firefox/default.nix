{ pkgs, ... }:

with builtins;

let
  arkenfox-userjs = fromJSON (readFile "${pkgs.extra-files.arkenfox-userjs}");
  custom-userjs = import ./userjs.nix;
  userjs = arkenfox-userjs // custom-userjs;
in {
  programs.firefox = {
    enable = true;
    extensions = with pkgs.nur.repos.rycee.firefox-addons; [
      ublock-origin
      i-dont-care-about-cookies
      link-cleaner
      plasma-integration
    ];
    profiles.default = {
      id = 0;
      settings = userjs;
      userChrome = readFile ./userChrome.css;
    };
  };
}
