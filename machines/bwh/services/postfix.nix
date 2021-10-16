{ lib, secrets, pkgs, ... }:

let
  common = ''
    server_host = ldapi://%2frun%2fopenldap%2fldapi
    version = 3
    bind = yes
    bind_dn = cn=postfix,ou=service,dc=poscat,dc=moe
    bind_pw = ${secrets.postfix-ldap-password}
    dereference = 3
  '';
  virtual-domains = pkgs.writeText "ldap-virtual-mailbox-domains.cf" ''
    ${common}
    search_base = ou=mail-domains,dc=poscat,dc=moe
    query_filter = (&(objectClass=dNSDomain)(dc=%s))
    result_attribute = dc
  '';
  virtual-maps = pkgs.writeText "ldap-virtual-mailbox-maps.cf" ''
    ${common}
    search_base = dc=poscat,dc=moe
    query_filter = (&(objectClass=postfixVirtualAccount)(mail=%s))
    result_attribute = mail
  '';
  virtual-alias-maps = pkgs.writeText "ldap-virtual-mailbox-alias-maps.cf" ''
    ${common}
    expansion_limit = 1
    search_base = dc=poscat,dc=moe
    query_filter = (&(objectClass=postfixVirtualAccount)(mailBox=%s))
    result_attribute = mail
  '';
  recipient-access = pkgs.writeText "recipient_access" ''
    no-reply@poscat.moe 550 This is a no reply account
  '';
in {
  services.postfix = {
    enable = true;
    hostname = "mail.poscat.moe";
    origin = "bwh.poscat.moe";
    domain = "mail.poscat.moe";
    destination = [ "bwh.poscat.moe" ];
    sslKey = "/var/lib/acme/poscat.moe-wildcard-rsa/key.pem";
    sslCert = "/var/lib/acme/poscat.moe-wildcard-rsa/fullchain.pem";
    config = {
      biff = false;
      disable_vrfy_command = true;
      strict_rfc821_envelopes = true;
      allow_percent_hack = false;
      swap_bangpath = false;
      recipient_delimiter = "+";

      smtp_tls_eckey_file = "/var/lib/acme/poscat.moe-wildcard/key.pem";
      smtp_tls_eccert_file = "/var/lib/acme/poscat.moe-wildcard/fullchain.pem";

      smtp_tls_security_level = "may";

      smtpd_tls_eckey_file = "/var/lib/acme/poscat.moe-wildcard/key.pem";
      smtpd_tls_eccert_file = "/var/lib/acme/poscat.moe-wildcard/fullchain.pem";
      smtpd_tls_eecdh_grade = "ultra";

      smtp_bind_address = secrets.mail-server-ip;

      smtpd_tls_mandatory_protocols = ">=TLSv1.2";
      smtpd_tls_mandatory_ciphers = "high";
      tls_high_cipherlist = "ECDHE+AESGCM:DHE+AESGCM";
      tls_ssl_options = "no_ticket no_compression";

      smtpd_tls_session_cache_database = "btree:\${data_directory}/smtpd_tlscache";
      smtp_tls_session_cache_database  = "btree:\${data_directory}/smtp_tlscache";

      smtpd_sasl_auth_enable = true;
      smtpd_sasl_path = "/run/dovecot2/auth";
      smtpd_sasl_type = "dovecot";

      smtpd_tls_auth_only = true;

      smtpd_sasl_security_options = "noanonymous, noplaintext";
      smtpd_sasl_tls_security_options = "noanonymous";

      smtpd_tls_received_header = true;
      smtpd_helo_required = true;

      smtpd_client_restrictions = lib.concatStringsSep "," [
        "permit_mynetworks"
        "permit_sasl_authenticated"
        "reject_unknown_client_hostname"
        "reject_unauth_pipelining"
      ];

      smtpd_helo_restrictions = lib.concatStringsSep "," [
        "permit_mynetworks"
        "permit_sasl_authenticated"
        "reject_invalid_helo_hostname"
        "reject_non_fqdn_helo_hostname"
        "reject_unauth_pipelining"
      ];

      smtpd_sender_restrictions = lib.concatStringsSep "," [
        "permit_mynetworks"
        "permit_sasl_authenticated"
        "reject_non_fqdn_sender"
        "reject_unknown_sender_domain"
        "reject_unauth_pipelining"
      ];

      smtpd_relay_restrictions = lib.concatStringsSep "," [
        "permit_mynetworks"
        "permit_sasl_authenticated"
        "reject_unauth_destination"
      ];

      smtpd_recipient_restrictions = lib.concatStringsSep "," [
        "permit_mynetworks"
        "permit_sasl_authenticated"
        "reject_non_fqdn_recipient"
        "reject_unknown_recipient_domain"
        "reject_unauth_pipelining"
        "reject_unverified_recipient"
        "check_policy_service unix:/run/dovecot2/quota-status"
        "check_recipient_access texthash:${recipient-access}"
      ];

      smtpd_data_restrictions = lib.concatStringsSep "," [
        "permit_mynetworks"
        "permit_sasl_authenticated"
        "reject_multi_recipient_bounce"
        "reject_unauth_pipelining"
      ];

      virtual_transport = "lmtp:unix:/run/dovecot2/lmtp";
      virtual_mailbox_domains = "ldap:${virtual-domains}";
      virtual_mailbox_maps = "ldap:${virtual-maps}";
      virtual_alias_maps = "ldap:${virtual-alias-maps}";
      address_verify_cache_cleanup_interval = "1h";
    };
    enableSubmission = true;
    submissionOptions = {
      smtpd_tls_security_level = "encrypt";
      tls_preempt_cipherlist = "yes";
    };
  };
}
