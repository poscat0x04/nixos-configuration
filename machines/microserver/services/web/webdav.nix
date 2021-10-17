{ pkgs, secrets, ... }:

{
  services.nginx = {
    additionalModules = [ pkgs.nginxModules.fancyindex ];
    virtualHosts."webdav.poscat.moe" = {
      onlySSL = true;
      listen = [
        {
          addr = "0.0.0.0";
          port = 8443;
          ssl = true;
        }
      ];
      useACMEHost = "poscat.moe-wildcard";
      locations = {
        "/" = {
          root = "/srv/http/webdav";
          extraConfig = ''
            auth_basic_user_file ${secrets.http-password-basic};
            auth_basic 'private webdav';

            fancyindex on;
            fancyindex_localtime on;
            fancyindex_exact_size off;
            fancyindex_show_path on;
            fancyindex_header "/theme/header.html";
            fancyindex_footer "/theme/footer.html";
            fancyindex_name_length 255;

            set $dest $http_destination;
            if (-d $request_filename) {
              rewrite ^(.*[^/])$ $1/;
              set $dest $dest/;
            }
            if ($request_method ~ (MOVE|COPY)) {
              more_set_input_headers 'Destination: $dest';
            }

            if ($request_method ~ MKCOL) {
              rewrite ^(.*[^/])$ $1/ break;
            }

            dav_methods PUT DELETE MKCOL COPY MOVE;
            dav_ext_methods PROPFIND OPTIONS;
            dav_access user:rw group:rw;
            create_full_put_path  on;

            client_max_body_size 0;
          '';
        };
        "/theme/" = {
          alias = "${pkgs.extra-files.nginx-fancyindex-flat-theme}/";
        };
      };
      extraConfig = ''
        error_page 497 301 =307 https://$host:$server_port$request_uri;
        add_header Strict-Transport-Security 'max-age=31536000' always;
      '';
    };
  };
  systemd.services.nginx.serviceConfig.ReadWritePaths = [ "/srv/http/webdav" ];
}
