{ pkgs, ... }:

with builtins;

let
  arkenfox-userjs = fromJSON (readFile "${pkgs.extra-files.arkenfox-userjs}");
  custom-userjs = import ./userjs.nix;
  userjs = arkenfox-userjs // custom-userjs;
in {
  programs.firefox = {
    enable = true;
    extensions = with pkgs.firefox-addons; [
      ublock-origin
      i-dont-care-about-cookies
      link-cleaner
      plasma-integration
      https-everywhere
      transmission-easy-client
      ctrl-number-to-switch-tabs
      privacy-badger
      pixiv-toolkit
      grammarly
      floccus
      absolute-enable-right-click
      save-to-the-wayback-machine
    ];
    profiles.default = {
      id = 0;
      settings = userjs;
      userChrome = readFile ./userChrome.css;
    };
  };
}
