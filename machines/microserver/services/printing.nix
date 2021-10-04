{ pkgs, ... }:

{
  services.printing = {
    enable = true;
    browsing = true;
    defaultShared = true;
    allowFrom = [ "all" ];
    listenAddresses = [ "10.1.10.1:631" ];
    drivers = with pkgs; [ epson-escpr ];
  };

  services.avahi.extraServiceFiles = {
    AirPrint-EPSON_L3151 = ''
      <?xml version="1.0" ?>
      <!DOCTYPE service-group
        SYSTEM 'avahi-service.dtd'>
      <service-group>
        <name replace-wildcards="yes">AirPrint EPSON_L3151 @ %h</name>
        <service>
          <type>_ipp._tcp</type>
          <subtype>_universal._sub._ipp._tcp</subtype>
          <port>631</port>
          <txt-record>txtvers=1</txt-record>
          <txt-record>qtotal=1</txt-record>
          <txt-record>Transparent=T</txt-record>
          <txt-record>URF=none</txt-record>
          <txt-record>rp=printers/EPSON_L3151</txt-record>
          <txt-record>note=EPSON L3150 Series</txt-record>
          <txt-record>product=(GPL Ghostscript)</txt-record>
          <txt-record>printer-state=3</txt-record>
          <txt-record>printer-type=0x100c</txt-record>
          <txt-record>pdl=application/octet-stream,application/pdf,application/postscript,application/vnd.cups-raster,image/gif,image/jpeg,image/png,image/tiff,image/urf,text/html,text/plain,application/vnd.adobe-reader-postscript,application/vnd.cups-pdf</txt-record>
        </service>
      </service-group>
    '';
  };
}
