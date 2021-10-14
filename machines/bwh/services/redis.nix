{ ... }:

{
  services.redis = {
    enable = true;
    vmOverCommit = true;
    settings = {
      maxmemory = "20mb";
      maxmemory-policy = "allkeys-lru";
    };
  };
}
