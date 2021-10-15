{ ... }:

{
  services.redis = {
    enable = true;
    vmOverCommit = true;
    settings = {
      maxmemory = "50mb";
      maxmemory-policy = "volatile-lru";
    };
  };
}
