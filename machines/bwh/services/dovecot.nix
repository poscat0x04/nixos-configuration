{ config, pkgs, secrets, ... }:

let
  pfCfg = config.services.postfix;
  ldap-filter = "(&(objectClass=postfixVirtualAccount)(uid=%u))";
  ldap-config = pkgs.writeText "dovecot-ldap.conf.ext" ''
    ldap_version = 3
    deref = always
    scope = subtree
    default_pass_scheme = SHA256-CRYPT
    blocking = no
    auth_bind = no

    uris = ldapi://%2frun%2fopenldap%2fldapi

    dn = cn=dovecot,ou=service,dc=poscat,dc=moe
    dnpass = ${secrets.dovecot-ldap-password}
    base = dc=poscat,dc=moe

    pass_attrs = mail=user,mailPassword=password
    pass_filter = ${ldap-filter}

    user_attrs = mailQuota=quota_rule=*:storage=%$
    user_filter = ${ldap-filter}

    iterate_attrs = uid=user
    iterate_filter = (objectClass=postfixVirtualAccount)
  '';
in {
  services.dovecot2 = {
    enable = true;
    sslServerKey = "/var/lib/acme/poscat.moe-wildcard/key.pem";
    sslServerCert = "/var/lib/acme/poscat.moe-wildcard/cert.pem";
    enablePAM = false;
    enablePop3 = false;
    enableImap = true;
    enableLmtp = true;
    mailUser = "vmail";
    mailGroup = "vmail";
    mailPlugins = {
      globally.enable = [ "zlib" ];
      perProtocol.imap.enable = [ "imap_zlib" ];
    };
    enableQuota = true;
    quotaGlobalPerUser = "100M";
    mailLocation = "sdbox:/mail/%d/%n";
    sieve = {
      enable = true;
      enableManageSieve = true;
    };
    mailboxes = {
      Junk = { specialUse = "Junk"; auto = "subscribe"; autoexpunge = "180d"; };
      Trash = { specialUse = "Trash"; auto = "subscribe"; };
      Archive = { specialUse = "Archive"; auto = "subscribe"; };
      Drafts = { specialUse = "Drafts"; auto = "subscribe"; };
      Flagged = { specialUse = "Flagged"; auto = "subscribe"; };
      Sent = { specialUse = "Sent"; auto = "subscribe"; };
      All = { specialUse = "All"; };
    };
    extraConfig = ''
      auth_cache_size=1M

      # enable SPECIAL-USE IMAP extension
      imap_capability = +SPECIAL-USE

      mail_server_admin = mailto:admin@poscat.moe

      mailbox_list_index_include_inbox = yes

      mail_attribute_dict = redis:host=127.0.0.1:port=6379:db=0

      ssl_cipher_list = ECDHE+AESGCM:DHE+AESGCM
      ssl_prefer_server_ciphers = yes

      protocol imap {
        imap_metadata = yes
      }

      service auth {
        unix_listener /run/dovecot2/auth {
          mode = 0660
          user = ${pfCfg.user}
          group = ${pfCfg.group}
        }
      }

      service lmtp {
        unix_listener /run/dovecot2/lmtp {
          mode = 0600
          user = ${pfCfg.user}
          group = ${pfCfg.group}
        }
      };

      passdb {
        driver = ldap
        args = ${ldap-config}
      }

      userdb {
        driver = ldap
        args = ${ldap-config}

        default_fields = uid=vmail gid=vmail

        result_failure = return-fail
        result_internalfail = return-fail
      }

      plugin {
        imap_compress_deflate_level = 6
      }
    '';
  };
}
