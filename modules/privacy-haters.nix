{ pkgs, lib, ... }:

with lib;

let
  privacy-haters = pkgs.fetchgit {
    url = "git://r-36.net/privacy-haters";
    rev = "6008a2a699ca07d3bed0354e62ca9e7f2334370c";
    sha256 = "0m4ky4rf5zmg0dgjn2dkxlyw0kw7bj7was739m224n4kn98j8saa";
  };
in {
  imports = [
    (../options/chromium.nix)
  ];

  config = {
    # http://r-36.net/scm/privacy-haters/file/hosts-gen/05-hosts.block.html
    networking.hostFiles = [
      (privacy-haters + "/hosts-gen/05-hosts.block")
    ];
    
  programs.chromium.cliArgs = lib.mkAfter [
      "--no-default-browser-check"
      "--no-pings"
      "--no-wifi"
      "--no-recovery-component"
      "--no-report-upload"
      /*
      "--safebrowsing-disable-download-protection"
      "--safebrowsing-disable-extension-blacklist"
      "--safebrowsing-disable-auto-update"
      "--arc-disable-app-sync"
      "--arc-disable-locale-sync"
      "--arc-disable-play-auto-install"
      "--arc-force-cache-app-icons"
      "--ash-disable-touch-exploration-mode"
      "--autofill-server-urlabout:config"
      "--block-new-web-contents"
      "--bwsi"
      "--cloud-print-uriabout:config"
      "--cloud-print-xmpp-endpointabout:config"
      "--connectivity-check-urlabout:config"
      "--crash-server-urlabout:config"
      "--cryptauth-http-hostabout:config"
      "--cryptauth-v2-http-hostabout:config"
      "--cryptauth-v2-enrollment-http-hostabout:config"
      "--data-reduction-proxy-config-urlabout:config"
      "--data-reduction-proxy-pingback-urlabout:config"
      "--data-reduction-proxy-server-experiments-disabled"
      "--device-management-urlabout:config"
      "--disable-background-networking"
      "--disable-client-side-phishing-detection"
      "--disable-data-reduction-proxy-warmup-url-fetch"
      "--disable-data-reduction-proxy-warmup-url-fetch-callback"
      "--disable-default-apps"
      "--disable-demo-mode"
      "--disable-device-disabling"
      "--disable-device-discovery-notifications"
      "--disable-dinosaur-easter-egg"
      "--disable-domain-reliability"
      "--disable-cloud-import"
      "--disable-component-cloud-policy"
      "--disable-eol-notification"
      "--disable-gaia-services"
      "--disable-login-screen-apps"
      "--disable-machine-cert-request"
      "--disable-notifications"
      "--disable-ntp-popular-sites"
      "--disable-ntp-most-likely-favicons-from-server"
      "--disable-offer-upload-credit-cards"
      "--disable-offer-store-unmasked-wallet-cards"
      "--disable-password-generation"
      "--disable-permission-action-reporting"
      "--disable-proximity-auth-bluetooth-low-energy-discovery"
      "--disable-push-api-background-mode"
      "--disable-remote-fonts"
      "--disable-remote-core-animation"
      "--disable-signin-promo"
      "--disable-signin-scoped-device-id"
      "--disable-suggestions-ui"
      "--disable-sync-app-list"
      "--disable-sync"
      "--disable-system-timezone-automatic-detection"
      "--disable-test-root-certs"
      "--disable-wake-on-wifi"
      "--feedback-serverabout:config"
      "--gcm-checkin-urlabout:config"
      "--gcm-mcs-endpointabout:config"
      "--gcm-registration-urlabout:config"
      "--google-apis-urlabout:config"
      "--google-base-urlabout:config"
      "--google-doodl-urlabout:config"
      "--google-urlabout:config"
      "--light"
      "--lso-urlabout:config"
      "--market-url-for-testingabout:config"
      "--oauth-account-manager-urlabout:config"
      "--optimization-guide-service-urlabout:config"
      "--override-metrics-upload-urlabout:config"
      "--permission-request-api-urlabout:config"
      "--realtime-reporting-urlabout:config"
      "--search-provider-logo-urlabout:config"
      "--sync-urlabout:config"
      "--third-party-doodle-urlabout:config"
      "--trace-upload-urlabout:config"
      "--variations-insecure-server-urlabout:config"
      "--variations-serverabout:config"
      */
    ];
  };
}
