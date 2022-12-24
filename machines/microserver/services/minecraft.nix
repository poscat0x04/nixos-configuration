{ pkgs, ... }:

{
  services = {
    minecraft-server = {
      enable = true;
      declarative = true;
      eula = true;
      jvmOpts = ''
        -Xms8G -Xmx8G -XX:+IgnoreUnrecognizedVMOptions -XX:+UnlockExperimentalVMOptions -XX:+UnlockDiagnosticVMOptions -XX:-OmitStackTraceInFastThrow -XX:+ShowCodeDetailsInExceptionMessages -XX:+DisableExplicitGC -XX:-UseParallelGC -XX:-UseParallelOldGC -XX:+PerfDisableSharedMem -XX:+UseZGC -XX:-ZUncommit -XX:ZUncommitDelay=300 -XX:ZCollectionInterval=5 -XX:ZAllocationSpikeTolerance=2.0 -XX:+AlwaysPreTouch -XX:+UseTransparentHugePages -XX:LargePageSizeInBytes=2M -XX:+UseLargePages -XX:+ParallelRefProcEnabled
      '';
      serverProperties = {
        difficulty = "hard";
        hardcore = false;
        max-players = 50;
        simulation-distance = 20;
        view-distance = 20;
        white-list = false;
        level-name = "world";
        level-seed = "3774440063627353373";
      };
      whitelist = {
        poscat = "abeab01a-1723-4562-8927-238910074ec6";
      };
      package = pkgs.minecraft-server.override {
        #url = "https://meta.fabricmc.net/v2/versions/loader/1.18.2/0.13.3/0.10.2/server/jar";
        url = "https://meta.fabricmc.net/v2/versions/loader/1.19/0.14.8/0.11.0/server/jar";
        sha1 = "f8n2rzfdmflyhn639cn50iwzn406vfl3";
        version = "1.19-fabric";
      };
    };

    sanoid = {
      enable = true;
      templates = {
        storage = {
          autoprune = true;
          autosnap = true;
          daily = 60;
          hourly = 72;
          monthly = 12;
          yearly = 3;
        };
      };
      datasets = {
        "mainpool/minecraft" = {
          useTemplate = [ "storage" ];
        };
      };
    };
  };

  systemd.services.minecraft-server.serviceConfig.Slice = "system-special-noproxy.slice";
}
