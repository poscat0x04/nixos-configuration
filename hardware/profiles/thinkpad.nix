{ ... }:

{
  imports = [
    ./fwupd.nix
  ];
  services.thinkfan = {
    enable = true;
    smartSupport = true;
    fans = [
      {
        type = "tpacpi";
        query = "/proc/acpi/ibm/fan";
      }
    ];
    levels = [
      [ 0   0   55    ]
      [ 1   48  60    ]
      [ 2   50  61    ]
      [ 3   52  63    ]
      [ 4   56  65    ]
      [ 5   59  66    ]
      [ 7   63  75    ]
      [ 127 70  32767 ]
    ];
    sensors = [
      {
        type = "hwmon";
        query = "/sys/class/hwmon";
        name = "coretemp";
        indices = [ 1 2 3 4 5 ];
      }
    ];
  };
}
