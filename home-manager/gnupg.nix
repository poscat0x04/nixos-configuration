{ config, ... }:

let
  homedir = config.programs.gpg.homedir;
in {
  programs.gpg = {
    enable = true;
    scdaemonSettings = {
      disable-ccid = true;
      pcsc-shared = true;
    };
    settings = {
      no-comments = true;
      no-emit-version = true;
      keyid-format = "short";
      with-fingerprint = true;
      with-subkey-fingerprint = true;
      keyserver = "hkps://keys.openpgp.org";
      personal-cipher-preferences = "AES256 AES192 AES";
      personal-digest-preferences = "SHA512 SHA384 SHA256";
      cert-digest-algo = "SHA512";
      default-preference-list = "SHA512 SHA384 SHA256 AES256 AES192 AES ZLIB BZIP2 ZIP Uncompressed";
    };
  };

  home.file = {
    "${homedir}/gpg-agent.conf".text = ''
      default-cache-ttl 3600
      default-cache-ttl-ssh 1800
      max-cache-ttl 648000
      max-cache-ttl-ssh 86400
    '';
    "${homedir}/sshcontrol".text = ''
      518455DD2FA1478688EBFB640EDABF3984768341
    '';
  };
}
