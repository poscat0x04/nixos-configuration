{ config, pkgs, ... }:

let
  luajit = pkgs.luajit_openresty;
  lua = rec {
    name = "lua";
    src = pkgs.fetchFromGitHub {
      name = "lua";
      owner = "openresty";
      repo = "lua-nginx-module";
      rev = "v0.10.22";
      sha256 = "sha256-TyeTL7/0dI2wS2eACS4sI+9tu7UpDq09aemMaklkUss=";
    };

    inputs = [ luajit ];

    preConfigure = let
      # fix compilation against nginx 1.23.0
      nginx-1-23-patch = pkgs.fetchpatch {
        url = "https://github.com/openresty/lua-nginx-module/commit/b6d167cf1a93c0c885c28db5a439f2404874cb26.patch";
        sha256 = "sha256-l7GHFNZXg+RG2SIBjYJO1JHdGUtthWnzLIqEORJUNr4=";
      };
    in ''
      export LUAJIT_LIB="${luajit}/lib"
      export LUAJIT_INC="$(realpath ${luajit}/include/luajit-*)"

      # make source directory writable to allow generating src/ngx_http_lua_autoconf.h
      lua_src=$TMPDIR/lua-src
      cp -r "${src}/" "$lua_src"
      chmod -R +w "$lua_src"
      patch -p1 -d $lua_src -i ${nginx-1-23-patch}
      export configureFlags="''${configureFlags//"${src}"/"$lua_src"}"
      unset lua_src
    '';

    allowMemoryWriteExecute = true;

    meta = with pkgs.lib; {
      description = "Embed the Power of Lua";
      homepage = "https://github.com/openresty/lua-nginx-module";
      license = with licenses; [ bsd2 ];
      maintainers = with maintainers; [ ];
    };
  };

  lua-resty-core = pkgs.fetchFromGitHub {
    owner = "openresty";
    repo = "lua-resty-core";
    rev = "v0.1.24";
    sha256 = "sha256-obwyxHSot1Lb2c1dNqJor3inPou+UIBrqldbkNBCQQk=";
  };
  lua-resty-lrucache = pkgs.fetchFromGitHub {
    owner = "openresty";
    repo = "lua-resty-lrucache";
    rev = "v0.13";
    sha256 = "sha256-4bb5o8QWNm6EtX8xC7euv8scZrZdOdKOpBdu4sWegU4=";
   };
   lua-resty-session = pkgs.fetchFromGitHub {
     owner = "bungle";
     repo = "lua-resty-session";
     rev = "5f2aed616d16fa7ca04dc40e23d6941740cd634d";
     sha256 = "n0m6/4JnUPoidM7oWKd+ZyNbb/X/h8w21ptCrFaA8SI=";
   };
   lua-resty-string = pkgs.fetchFromGitHub {
     owner = "openresty";
     repo = "lua-resty-string";
     rev = "e6b80ac31dd9ff26bf444e50f5d7bda1089f972b";
     sha256 = "50/PHKbOMf4FfWTKEnBYkwvsR2pr3UveruSnNnl46QU=";
   };
   lua-resty-openidc = pkgs.fetchFromGitHub {
     owner = "oldium";
     repo = "lua-resty-openidc";
     rev = "4040119d8ebcd35df3bc35e60e20dcbfa566f13b";
     sha256 = "b1ORKZKny+96Ekls3VVNL3DxY+L6dwJ0FfUXSWgIMPQ=";
   };
   lua-resty-redis = pkgs.fetchFromGitHub {
     owner = "openresty";
     repo = "lua-resty-redis";
     rev = "bbbc47baf35e5a47539456371795b5e6ed67ef75";
     sha256 = "ZIN2QGkOzC8uFR5cSphNCEjzp3GG1wAAwSILOPVSrnA=";
   };
   lua-ffi-zlib = pkgs.fetchFromGitHub {
     owner = "hamishforbes";
     repo = "lua-ffi-zlib";
     rev = "61e95cb434e4047c8bc65a180c293a05bf754416";
     sha256 = "l3zN6amZ6uUbOl7vt5XF+Uyz0nbDrYgcaQCWRFSN22Q=";
   };

   luaPkgPath = builtins.concatStringsSep ";" [
     "${pkgs.luajitPackages.lua-resty-core}/lib/lua/5.1/?.lua"
     "${pkgs.luajitPackages.lua-resty-lrucache}/lib/lua/5.1/?.lua"
     "${pkgs.luajitPackages.lua-resty-http}/share/lua/5.1/?.lua"
     "${pkgs.luajitPackages.lua-cjson}/share/lua/5.1/?.lua"
     "${pkgs.luajitPackages.lua-resty-jwt}/share/lua/5.1/?.lua"
     "${pkgs.luajitPackages.lua-resty-openssl}/share/lua/5.1/?.lua"
     "${lua-resty-session}/lib/?.lua"
     "${lua-resty-string}/lib/?.lua"
     "${lua-resty-openidc}/lib/?.lua"
     "${lua-resty-redis}/lib/?.lua"
     "${lua-ffi-zlib}/lib/?.lua"
   ];

   luaPkgCPath = builtins.concatStringsSep ";" [
     "${pkgs.luajitPackages.lua-cjson}/lib/lua/5.1/?.so"
   ];
in{
  imports = [ ./acme.nix ];

  sops.secrets.nginx-secret = {};

  services.nginx = {
    enable = true;
    group = "acme";
    package = pkgs.nginxMainline;
    enableReload = true;
    additionalModules = [
      lua
      pkgs.nginxModules.brotli
      pkgs.nginxModules.develkit
    ];
    recommendedOptimisation = true;
    recommendedTlsSettings = true;
    recommendedGzipSettings = true;

    commonHttpConfig = ''
      brotli on;
      brotli_types
        application/atom+xml
        application/javascript
        application/json
        application/xml
        application/xml+rss
        image/svg+xml
        text/css
        text/javascript
        text/plain
        text/xml;
      lua_package_path "${luaPkgPath}";
      lua_package_cpath "${luaPkgCPath}";
      lua_ssl_trusted_certificate /etc/ssl/certs/ca-certificates.crt;
      lua_ssl_verify_depth 5;
      lua_shared_dict discovery 1m;
      lua_shared_dict jwks 1m;
      lua_code_cache on;

      init_by_lua_block {
        require "resty.session".init({
          remember = true,
          storage = "redis",
          redis = {
            socket = "unix:/run/redis/redis.sock",
            database = 5,
          },
        })

        local cjson = require "cjson"
        local cred_dir = os.getenv("CREDENTIALS_DIRECTORY")
        io.input(cred_dir .. "/secret")
        local f = io.read("*all")
        secret = cjson.decode(f)
      }
    '';

    resolver.addresses = [ "127.0.0.1" ];

    sslCiphers = "ECDHE+AESGCM:DHE+AESGCM";
    sslProtocols = "TLSv1.2 TLSv1.3";
    eventsConfig = ''
      worker_connections 1024;
      use epoll;
      multi_accept on;
    '';
    appendConfig = ''
      worker_processes auto;
      worker_rlimit_nofile 100000;
    '';
    virtualHosts.default = {
      listen = [
        {
          addr = "0.0.0.0";
          port = 80;
        }
      ];
      serverName = "_";
      default = true;
      extraConfig = ''
        return 444;
      '';
    };
  };

  systemd.services.nginx.serviceConfig = {
    LimitNOFILE = "100000";
    SupplementaryGroups = [ "redis" ];
    LoadCredential = [
      "secret:${config.sops.secrets.nginx-secret.path}"
    ];
  };
}
