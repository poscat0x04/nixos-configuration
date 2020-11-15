{ ... }:

{
  programs.ssh.knownHosts = {
    rpi = {
      hostNames = [
        "rpi.local"
        "[home.poscat.moe]:4343"
        "192.168.1.187"
      ];
      publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOyJs5voxOLxf4e0TVlc6baKni4r6o8lTphm6QOXE6vC";
    };
    github = {
      hostNames = [
        "github.com"
      ];
      publicKey = "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAq2A7hRGmdnm9tUDbO9IDSwBK6TbQa+PXYPCPy6rbTrTtw7PHkccKrpp0yVhp5HdEIcKr6pLlVDBfOLX9QUsyCOV0wzfjIJNlGEYsdlLJizHhbn2mUjvSAHQqZETYP81eFzLQNnPHt4EVVUh7VfDESU84KezmD5QlWpXLmvU31/yMf+Se8xhHTvKSCZIFImWwoG6mbUoWf9nzpIoaSjB+weqqUUmpaaasXVal72J+UX2B+2RPW3RcT0eOzQgqlJL3RKrTJvdsjE3JEAvGq3lGHSZXy28G3skua2SmVi/w4yCE6gbODqnTWlg7+wC604ydGXA8VJiS5ap43JXiUFFAaQ==";
    };
    bwh = {
      hostNames = [
        "64.64.228.47"
      ];
      publicKey = "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBOhhV25cyPJv+HalSci4r++WbMox80jZDwjtcLDSOYIgxxqQf9M5ZRGCflHMa/tU8S7C3HLCRJnN9qk5BBjpJtk=";
    };
    router = {
      hostNames = [
        "home.poscat.moe"
        "192.168.1.1"
      ];
      publicKey = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCS0m1Pqugg7JmizHY0ub7AjYL3xkugeQsO8GKwczLRBalUgbzscrktUbnU5UBST3Oh+91yXOG+Xv1TC6VhJwwGZW+tARWWmz5ZsA7KCDLRE7ZakqoF76lg9FFq4nmlKrMwu7bTmObceGZ16vBUpapa+UD995aRw1L+Ga+4Socal1kfTdmdQHAGtOhHH9fBzflMaYvAAubXy5VqRNiubd1M8Vy1nxerA9PIEGS/xNDukhVw+p7EdLtrMgR0/yOqqYqXifsNvbCGsVQoUsUbjuEbyRodfeL8rPQIzZj6FpVy4vtYTRIA0S90zENMUIrk0imxIIaKxPhGL5oaCGlYem/N";
    };
  };
}
