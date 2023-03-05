self: super:

{
  mtprotoproxy = super.mtprotoproxy.overrideAttrs (newAttrs: oldAttrs: rec {
    version = "1.1.1";
    src = self.fetchFromGitHub {
      owner = "alexbers";
      repo = "mtprotoproxy";
      rev = "v${version}";
      sha256 = "tQ6e1Y25V4qAqBvhhKdirSCYzeALfH+PhNtcHTuBurs=";
    };
  });
}
