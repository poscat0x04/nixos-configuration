{ ... }:

{
  services.redis = {
    enable = true;
    vmOverCommit = true;
  };
}
