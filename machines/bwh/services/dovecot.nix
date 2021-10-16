{ config, pkgs, secrets, ... }:

let
  pfCfg = config.services.postfix;
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
    pass_filter = (&(objectClass=postfixVirtualAccount)(uid=%u))

    user_attrs = mailQuota=quota_rule=*:storage=%$
    user_filter = (&(objectClass=postfixVirtualAccount)(mail=%u))

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
      globally.enable = [ "zlib" "quota" ];
      perProtocol.imap.enable = [ "imap_zlib" "imap_quota" ];
    };
    mailLocation = "sdbox:/var/vmail/%d/%n";
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

      # set the home dirs of virtual users
      mail_home = /home/virtual/%d/%n

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
        unix_listener auth {
          mode = 0660
          user = ${pfCfg.user}
          group = ${pfCfg.group}
        }
      }

      service lmtp {
        unix_listener lmtp {
          mode = 0600
          user = ${pfCfg.user}
          group = ${pfCfg.group}
        }
      }

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

      plugin {
        quota = count:User quota
        quota_rule = *:storage=100M
        quota_grace = 10%%
        quota_status_success = DUNNO
        quota_status_nouser = DUNNO
        quota_status_overquota = "552 5.2.2 Mailbox is full"
        quota_vsizes = yes
      }

      service quota-status {
        executable = ${pkgs.dovecot}/libexec/dovecot/quota-status -p postfix
        unix_listener quota-status {
          mode = 0600
          user = ${pfCfg.user}
          group = ${pfCfg.group}
        }
      }
    '';
  };
}
