{
  services.redis = {
    vmOverCommit = true;
    servers."" = {
      enable = true;
      port = 0;
      settings = {
        maxmemory-policy = "volatile-lru";
      };
    };
  };
}
