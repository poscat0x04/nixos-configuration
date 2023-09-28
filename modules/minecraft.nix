{ lib, pkgs, ... }:

let
  fabric-server = pkgs.minecraft-server.override {
    url = "https://meta.fabricmc.net/v2/versions/loader/1.20.1/0.14.22/0.11.2/server/jar";
    sha1 = "fdxgc1ri9lyxb9qlhxqfh9w0jky7p753";
    version = "1.20.1";
    jre_headless = pkgs.javaPackages.compiler.openjdk17.headless;
  };

  opts = builtins.concatStringsSep " " [
    "-Xms6G"
    "-Xmx6G"
    "-XX:+UnlockExperimentalVMOptions"
    "-XX:+UnlockDiagnosticVMOptions"
    "-XX:+AlwaysActAsServerClassMachine"
    "-XX:+AlwaysPreTouch"
    "-XX:+DisableExplicitGC"
    "-XX:+UseNUMA"
    "-XX:NmethodSweepActivity=1"
    "-XX:ReservedCodeCacheSize=400M"
    "-XX:NonNMethodCodeHeapSize=12M"
    "-XX:ProfiledCodeHeapSize=194M"
    "-XX:NonProfiledCodeHeapSize=194M"
    "-XX:-DontCompileHugeMethods"
    "-XX:MaxNodeLimit=240000"
    "-XX:NodeLimitFudgeFactor=8000"
    "-XX:+UseVectorCmov"
    "-XX:+PerfDisableSharedMem"
    "-XX:+UseFastUnorderedTimeStamps"
    "-XX:+UseCriticalJavaThreadPriority"
    "-XX:ThreadPriorityPolicy=1"
    "-XX:AllocatePrefetchStyle=3"
    "-XX:+UseZGC -XX:AllocatePrefetchStyle=1 -XX:-ZProactive"
    "-XX:+UseLargePages -XX:LargePageSizeInBytes=2m"
  ];
in {
  boot.kernel.sysctl = {
    "vm.nr_hugepages" = lib.mkForce 4096;
  };

  networking.firewall = {
    allowedUDPPorts = [ 19132 25565 ];
    allowedTCPPorts = [ 25565 ];
  };

  services = {
    minecraft-server = {
      enable = true;
      eula = true;
      declarative = true;
      package = fabric-server;
      whitelist = {
        poscat = "abeab01a-1723-4562-8927-238910074ec6";
        ".DerivingVia" = "00000000-0000-0000-0009-01fa4fef969e";
      };
      serverProperties = {
        enable-query = true;
        enable-rcon = true;
        "rcon.password" = "password";

        gamemode = "survival";
        difficulty = "hard";
        level-seed = 3774440063627353373;
        simulation-distance = 10;
        view-distance = 16;
        sync-chunk-writes = false;
        motd = "Poscat's minecraft server";
        white-list = true;
        enforce-secure-profile = false;
        initial-enabled-packs = "vanilla, bundle";
      };
      jvmOpts = opts;
    };
    nginx.virtualHosts = {
      "mc.poscat.moe" = {
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
        locations = {
          "/" = {
            proxyPass = "http://127.0.0.1:8100";
            extraConfig = ''
              proxy_set_header X-Real-IP $remote_addr;
              proxy_set_header Host $host;
            '';
          };
        };
      };
    };
    sanoid = {
      enable = true;
      datasets."tank/minecraft" = {
        autosnap = true;
        autoprune = true;
        hourly = 72;
        daily = 31;
        weekly = 12;
        monthly = 24;
        yearly = 4;
      };
    };
  };

  systemd.services.minecraft-server.serviceConfig = {
    RestrictAddressFamilies = [ "AF_UNIX" ];
    Slice = "system-noproxy.slice";
  };

  environment.systemPackages = [ pkgs.mcrcon pkgs.ferium ];
}
