{ pkgs, lib, config, ... }:

{
  environment = {
    etc."chromium/native-messaging-hosts/org.kde.plasma.browser_integration.json".source = "${pkgs.plasma-browser-integration}/etc/chromium/native-messaging-hosts/org.kde.plasma.browser_integration.json";
    sessionVariables = {
      GOOGLE_DEFAULT_CLIENT_ID = "77185425430.apps.googleusercontent.com";
      GOOGLE_DEFAULT_CLIENT_SECRET = "OTJgUOQcT7lO7GsGZq2G4IlT";
    };
    systemPackages = [
      (pkgs.chromium.override {
        commandLineArgs = lib.intersperse " " ([
          "--no-default-browser-check"
          "--no-pings"
          "--no-wifi"
          "--no-recovery-component"
          "--no-report-upload"
          "--password-store=basic"
          "--ignore-gpu-blocklist"
          "--enable-gpu-rasterization"
          "--enable-zero-copy"
          "--enable-accelerated-video-decode"
          "--disable-features=UseOzonePlatform"
          "--enable-features=VaapiVideoDecoder"
          "--disable-features=UseSkiaRenderer"
          "--use-gl=desktop"
        ]);
      })
    ];
  };

  programs.chromium = {
    enable = true;
    extensions = [
      # Google scholar
      "ldipcbpaocekfooobnbcddclnhejkcpn"
      # atomic chrome
      "lhaoghhllmiaaagaffababmkdllgfcmc"
      # hide twitter trends
      "lapmncfnibdclongbkleadoicnkhknia"
      # bitwarden
      "nngceckbapebfimnlniiiahkandclblb"
      # cxmooc tools
      "kkicgcijebblepmephnfganiiochecfl"
      # bypass paywall
      "dcpihecpambacapedldabdbpakmachpb;https://cdn.jsdelivr.net/gh/iamadamdev/bypass-paywalls-chrome/src/updates/updates.xml"
      # tampermonkey
      "dhdgffkkebhmkfjojejmpbldmpobfkfo"
      # pixiv downloader
      "dkndmhgdcmjdmkdonmbgjpijejdcilfh"
      # floccus
      "fnaicdffflnofjppbagibeoednhnbjhg"
      "cobieddmkhhnbeldhncnfcgcaccmehgn"
      "jdocbkpgdakpekjlhemmfcncgdjeiika"
      "cjpalhdlnbpafiamejdnhcphjbkeiagm"
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
