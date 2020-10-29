{ pkgs, lib, config, ... }:

{
  imports = [
    ../options/chromium.nix
  ];

  environment = {
    etc."chromium/native-messaging-hosts/org.kde.plasma.browser_integration.json".source = "${pkgs.plasma-browser-integration}/etc/chromium/native-messaging-hosts/org.kde.plasma.browser_integration.json";
    systemPackages = [
      (pkgs.chromium.override {
        enableVaapi = true;
        commandLineArgs = lib.intersperse " " ([
          "--password-store=basic"
          "--ignore-gpu-blacklist"
          "--enable-gpu-rasterization"
        ] ++ config.programs.chromium.cliArgs);
      })
    ];
  };

  programs.chromium = {
    enable = true;
    extensions = [
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
