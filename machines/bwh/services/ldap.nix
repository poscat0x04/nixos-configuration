{ config, ... }:

let
  openldap = config.services.openldap.package;
in {
  services.openldap = {
    enable = true;
    settings = {
      attrs = {
        olcLogLevel = "128";
      };
      children = {
        "cn=schema".includes = [
          "${openldap}/etc/schema/core.ldif"
          "${openldap}/etc/schema/cosine.ldif"
          "${openldap}/etc/schema/inetorgperson.ldif"
          "${openldap}/etc/schema/openldap.ldif"
          "${openldap}/etc/schema/misc.ldif"
          "${openldap}/etc/schema/nis.ldif"
          "${openldap}/etc/schema/ppolicy.ldif"
          ./postfix-dovecot.ldif
        ];
        "olcDatabase={-1}frontend" = {
          attrs = {
            objectClass = "olcDatabaseConfig";
            olcDatabase = "{-1}frontend";
            olcAccess = "to * by * read";
          };
        };
        "olcDatabase={0}config" = {
          attrs = {
            objectClass = "olcDatabaseConfig";
            olcDatabase = "{0}config";
            olcRootPW = "{SSHA}Wtw8nPjtK1U3Mevuh6IUtANy6Snsiuse";
          };
        };
        "olcDatabase={1}mdb" = {
          attrs = {
            objectClass = [ "olcDatabaseConfig" "olcMdbConfig" ];
            olcDatabase = "{1}mdb";
            olcDbDirectory = "/var/lib/openldap/poscat";
            olcDbIndex = [ "objectClass eq" ];
            olcSizeLimit = "unlimited";
            olcSuffix = "dc=poscat,dc=moe";
            olcRootDN = "cn=admin,dc=poscat,dc=moe";
            olcRootPW = "{SSHA}Wtw8nPjtK1U3Mevuh6IUtANy6Snsiuse";
            olcAccess = [
              ''
                {0}to dn.children="ou=customers,dc=poscat,dc=moe"
                  by dn="cn=dovecot,ou=service,dc=poscat,dc=moe" read
                  by dn="cn=postfix,ou=service,dc=poscat,dc=moe" read
              ''
              ''
                {1}to dn.children="ou=trusted,dc=poscat,dc=moe"
                  by dn="cn=dovecot,ou=service,dc=poscat,dc=moe" read
                  by dn="cn=postfix,ou=service,dc=poscat,dc=moe" read
              ''
              ''
                {2}to dn.children="ou=mail-services,dc=poscat,dc=moe"
                  by dn="cn=dovecot,ou=service,dc=poscat,dc=moe" read
                  by dn="cn=postfix,ou=service,dc=poscat,dc=moe" read
              ''
              ''
                {3}to dn.children="ou=mail-domains,dc=poscat,dc=moe"
                  by dn="cn=postfix,ou=service,dc=poscat,dc=moe" read
              ''
              ''
                {4}to *
                  by dn="cn=dovecot,ou=service,dc=poscat,dc=moe" search
                  by dn="cn=postfix,ou=service,dc=poscat,dc=moe" search
                  by self read
                  by * auth
              ''
            ];
          };
        };
      };
    };
    urlList = [ "ldapi://%%2frun%%2fopenldap%%2fldapi" ];
  };
}
