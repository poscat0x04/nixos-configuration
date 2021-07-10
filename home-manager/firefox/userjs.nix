{
  ## Enable hardware video acceleration
  # https://bugzilla.mozilla.org/show_bug.cgi?id=1619585
  "media.ffmpeg.vaapi.enabled" = true;
  "media.ffvpx.enabled" = false;
  "media.rdd-vpx.enabled" = false;
  "security.sandbox.content.level" = 0;
  "media.navigator.mediadatadecoder_vpx_enabled" = true;

  ## Enable WebRender compositor
  "gfx.webrender.all" = true;

  ## Privacy stuff
  # Disable VR
  "dom.vr.enabled" = false;
  # Disable sensor API
  "device.sensors.enabled" = false;
  # Disable battery fingerprinting
  "dom.battery.enabled" = false;
  # Disable gamepad API
  "dom.gamepad.enabled" = false;
  # Enable tracking protection
  "privacy.trackingprotection.enabled" = true;
  # Disable SB
  "browser.safebrowsing.malware.enabled" = false;
  "browser.safebrowsing.phishing.enabled" = false;
  "browser.safebrowsing.downloads.enabled" = false;
  # Disable letterboxing
  "privacy.resistFingerprinting.letterboxing" = false;
  # Disable OCSP
  "security.OCSP.require" = false;
  # Don't clear stuff on shutdown
  "privacy.sanitize.sanitizeOnShutdown" = false;
  # Don't save passwords
  "signon.rememberSignons" = false;
  # Pixiv
  "network.http.referer.XOriginPolicy" = 0;

  ## Ergonomics
  # Enable search suggestions
  "browser.search.suggest.enabled" = true;
  "browser.urlbar.suggest.searches" = true;
  # Enable searching implicitly in address bar
  "keyword.enabled" = true;
  # Hide title bar
  "browser.tabs.drawInTitlebar" = true;
  # Consolas
  "font.size.monospace.x-western" = 14;
}
