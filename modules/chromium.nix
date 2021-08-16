{ pkgs, lib, config, ... }:

{
  imports = [
    ../options/chromium.nix
  ];

  environment = {
    etc."chromium/native-messaging-hosts/org.kde.plasma.browser_integration.json".source = "${pkgs.plasma-browser-integration}/etc/chromium/native-messaging-hosts/org.kde.plasma.browser_integration.json";
    sessionVariables = {
      GOOGLE_DEFAULT_CLIENT_ID = "77185425430.apps.googleusercontent.com";
      GOOGLE_DEFAULT_CLIENT_SECRET = "OTJgUOQcT7lO7GsGZq2G4IlT";
    };
    systemPackages = [
      (pkgs.chromium.override {
        commandLineArgs = lib.intersperse " " ([
          "--password-store=basic"
          "--ignore-gpu-blacklist"
          "--enable-gpu-rasterization"
          "--use-gl=desktop"
          "--enable-accelerated-video-decode"
          "--enable-features=VaapiVideoDecoder"
        ] ++ config.programs.chromium.cliArgs);
      })
    ];
  };

  programs.chromium = {
    enable = true;
    extensions = [
      # tampermonkey
      "dhdgffkkebhmkfjojejmpbldmpobfkfo"
      # pixiv downloader
      "dkndmhgdcmjdmkdonmbgjpijejdcilfh"
      # floccus
      "fnaicdffflnofjppbagibeoednhnbjhg"
      "cobieddmkhhnbeldhncnfcgcaccmehgn"
      "jdocbkpgdakpekjlhemmfcncgdjeiika"
      "cjpalhdlnbpafiamejdnhcphjbkeiagm"
      "fdjamakpfbbddfjaooikfcpapjohcfmg"
      "kbfnbcaeplbcioakkpcpgfkobkghlhen"
      "ekhagklcjbdpajgpjgmbionohlpdbjgc"
      "eebpioaailbjojmdbmlpomfgijnlcemk"
      "chphlpgkkbolifaimnlloiipkdnihall"
      "fdpohaocaechififmbbbbbknoalclacl"
      "cimiefiiaegbelhefglklhhakcgmhkai"
      "gcbommkclmclpchllfjekcdonpmejbdp"
      "mmpehpemlpopfclagkfejnlmpfgmekfl"
      "jnlldhggdfnbabnjbgahoabglgmjbhdl"
      "babdjpjkdmdppnlgjlpgiknmbdblmdbd"
      "cmkphjiphbjkffbcbnjiaidnjhahnned"
    ];
  };
}
