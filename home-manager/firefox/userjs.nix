{
  ## Enable hardware video acceleration
  # https://bugzilla.mozilla.org/show_bug.cgi?id=1619585
  "security.sandbox.content.level" = 0;
  "media.ffmpeg.vaapi.enabled" = true;
  "media.ffvpx.enabled" = false;
  "media.av1.enabled" = false;

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
}
