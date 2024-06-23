{ config, ... }:

{
  sops.secrets.gitea-smtp-password = {};

  services = {
    gitea = {
      enable = true;
      mailerPasswordFile = "/run/credentials/gitea.service/smtp-password";
      database = {
        user = "gitea";
        name = "gitea";
        host = "/run/postgresql";
        type = "postgres";
        socket = "/run/postgresql";
        createDatabase = false;
      };
      settings = {
        repository.DEFAULT_BRANCH = "master";
        "repository.pull-request" = {
          DEFAULT_MERGE_STYLE = "rebase";
          POPULATE_SQUASH_COMMENT_WITH_COMMIT_MESSAGES = true;
        };
        "repository.upload" = {
          FILE_MAX_SIZE = 100;
          MAX_FILES = 100;
        };
        "repository.signing" = {
          INITIAL_COMMIT = "never";
          DEFAULT_TRUST_MODEL = "committer";
        };
        server = {
          PROTOCOL = "http";
          HTTP_ADDR = "127.0.0.1";
          HTTP_PORT = 23000;
          DOMAIN = "git.poscat.moe";
          ROOT_URL = "https://git.poscat.moe/";
          SSH_DOMAIN = "ssh.git.poscat.moe";
        };
        service = {
          REGISTER_EMAIL_CONFIRM = true;
          ENABLE_NOTIFY_MAIL = true;
          ENABLE_CAPTCHA = true;
          CAPTCHA_TYPE = "cfturnstile";
          CF_TURNSTILE_SECRET = "0x4AAAAAAALWOmpdelMjDXZIvDUsYozPkjw";
          CF_TURNSTILE_SITEKEY = "0x4AAAAAAALWOl67Q3xMfiqx";
        };
        queue = {
          TYPE = "redis";
          CONN_STR = "network=unix,addr=/run/redis/redis.sock,pool_size=100,db=3";
        };
        cache = {
          ADAPTER = "redis";
          HOST = "network=unix,addr=/run/redis/redis.sock,pool_size=100,db=1";
        };
        session = {
          PROVIDER = "redis";
          PROVIDER_CONFIG = "network=unix,addr=/run/redis/redis.sock,pool_size=100,db=2";
        };
        log.LEVEL = "Warn";
        metrics = {
          ENABLED = true;
          ENABLED_ISSUE_BY_LABEL = true;
          ENABLED_ISSUE_BY_REPOSITORY = true;
        };
        mirror.DEFAULT_INTERVAL = "1h";
        openid.ENABLE_OPENID_SIGNIN = true;
        federation.ENABLED = true;
        actions.ENABLED = true;
        attachment = {
          MAX_SIZE = 20;
          MAX_FILES = 10;
        };
        mailer = {
          ENABLED = true;
          FROM = "Gitea <no-reply@poscat.moe>";
          PROTOCOL = "smtp+starttls";
          SMTP_ADDR = "smtp.mail.me.com";
          SMTP_PORT = 587;
          USER = "weihaoyubnds@icloud.com";
        };
        "git.timeout" = {
          MIGRATE = 3600;
          MIRROR = 1800;
        };
        indexer = {
          ISSUE_INDEXER_TYPE = "elasticsearch";
          ISSUE_INDEXER_CONN_STR = "http://127.0.0.1:9201";
          REPO_INDEXER_ENABLED = true;
          REPO_INDEXER_TYPE = "elasticsearch";
          REPO_INDEXER_CONN_STR = "http://127.0.0.1:9201";
        };
        oauth2 = {
          ENABLE = true;
          REFRESH_TOKEN_EXPIRATION_TIME = 2160;
        };
        security = {
          LOGIN_REMEMBER_DAYS = 90;
        };
      };
      lfs.enable = true;
    };
    nginx = {
      virtualHosts."git.poscat.moe" = {
        onlySSL = true;
        useACMEHost = "poscat.moe-wildcard";
        kTLS = true;
        listen = [
          {
            addr = "0.0.0.0";
            port = 8443;
            ssl = true;
          }
          {
            addr = "[::0]";
            port = 8443;
            ssl = true;
          }
        ];
        locations."/" = {
          proxyPass = "http://127.0.0.1:23000";
          recommendedProxySettings = true;
        };
        extraConfig = ''
          error_page 497 301 =307 https://$host$request_uri;
          add_header Strict-Transport-Security 'max-age=31536000' always;
        '';
      };
    };
  };

  systemd.services.gitea.serviceConfig = {
    SupplementaryGroups = [ "redis" ];
    LoadCredential = [
      "smtp-password:${config.sops.secrets.gitea-smtp-password.path}"
    ];
  };
}
