{ config, secrets, pkgs, ... }:

let
  cfg = config.services.rspamd;
in {
  services = {
    rspamd = {
      enable = true;
      workers = {
        controller = {
          includes = [ "$CONFDIR/worker-controller.inc" ];
          bindSockets = [
            "127.0.0.1:11334"
            {
              socket = "/run/rspamd/rspamd-contoller.sock";
              mode = "0666";
              owner = cfg.user;
              group = cfg.group;
            }
          ];
        };
      };
      locals = {
        "worker-controller.inc" = {
          text = ''
            secure_ip = "0.0.0.0/0";
          '';
        };
        "dkim_signing.conf" = {
          text = ''
            path = "/var/lib/rspamd/dkim/$domain.$selector.key";
            selector = "dkim";
            check_pubkey = true;
            allow_pubkey_mismatch = false;
          '';
        };
        "milter_headers.conf" = {
          text = ''
            extended_spam_headers = true;
          '';
        };
        "redis.conf" = {
          text = ''
            servers = "127.0.0.1:6379";
            db = 1;
          '';
        };
        "classifier-bayes.conf" = {
          text = ''
            cache {
              backend = "redis";
            }
            autolearn = true;
            expire = 180d;
          '';
        };
        "mx_check.conf" = {
          text = ''
            enabled = true;
            timeout = 3.0;
            expire_novalid = 3600;
          '';
        };
        "phishing.conf" = {
          text = ''
            openphish_enabled = true;
            phishtank_enabled = true;
          '';
        };
        "replies.conf" = {
          text = ''
            action = "no action";
          '';
        };
        "reputation.conf" = {
          text = ''
            rules {
              ip_reputation = {
                selector "ip" {
                }
                symbol = "IP_REPUTATION";
              }

              spf_reputation = {
                selector "spf" {
                }
                symbol = "SPF_REPUTATION";
              }

              dkim_reputation = {
                selector "dkim" {
                }
                symbol = "DKIM_REPUTATION";
              }

              url_reputation = {
                selector "url" {
                }
                symbol = "URL_REPUTATION";
              }

              generic_reputation = {
                selector "generic" {
                  selector = "ip";
                }
                symbol = "GENERIC_REPUTATION";
              }
            }
          '';
        };
        "groups.conf" = {
          text = ''
            group "reputation" {
              symbols = {
                "IP_REPUTATION_HAM" {
                  weight = 1.0;
                }

                "IP_REPUTATION_SPAM" {
                  weight = 4.0;
                }

                "DKIM_REPUTATION" {
                  weight = 1.0;
                }

                "SPF_REPUTATION_HAM" {
                  weight = 1.0;
                }

                "SPF_REPUTATION_SPAM" {
                  weight = 4.0;
                }

                "URL_REPUTATION_HAM" {
                  weight = 1.0;
                }

                "URL_REPUTATION_SPAM" {
                  weight = 4.0;
                }
              }
            }
          '';
        };
        "rbl.conf" = {
          text = ''
          '';
        };
        "url_redirector.conf" = {
          text = ''
            redirector_hosts_map = "''${CONFDIR}/maps.d/redirectors.inc";
          '';
        };
      };
      overrides = {
        "milter_headers.conf" = {
          text = ''
            extended_spam_headers = true;
          '';
        };
      };
      postfix = {
        enable = true;
        config = {
          milter_protocol = "6";
          milter_default_action = "accept";
          smtpd_milters = "unix:/run/rspamd/rspamd-milter.sock";
          non_smtpd_milters = "unix:/run/rspamd/rspamd-milter.sock";
          milter_mail_macros = "i {mail_addr} {client_addr} {client_name} {auth_authen}";
        };
      };
    };

    nginx = {
      additionalModules = [ pkgs.nginxModules.http-digest-auth ];
      virtualHosts."rspamd.poscat.moe" = {
        forceSSL = true;
        useACMEHost = "poscat.moe-wildcard";
        listen = [
          {
            addr = "0.0.0.0";
            port = 443;
            ssl = true;
          }
          {
            addr = "0.0.0.0";
            port = 80;
            ssl = false;
          }
        ];
        locations = {
          "/" = {
            proxyPass = "http://unix:/run/rspamd/rspamd-contoller.sock";
            extraConfig = ''
              auth_digest_user_file ${secrets.http-password-digest};
              auth_digest 'rspamd admin';
              proxy_set_header X-Real-IP $remote_addr;
              proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
              proxy_set_header Host $host;
            '';
          };
        };
        extraConfig = ''
          add_header Strict-Transport-Security 'max-age=31536000' always;
        '';
      };
    };
  };
}
