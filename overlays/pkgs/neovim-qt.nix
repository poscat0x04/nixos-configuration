self: super:

{
  neovim-qt-unwrapped = super.neovim-qt-unwrapped.overrideAttrs (_: {
    src = super.fetchFromGitHub {
      owner = "equalsraf";
      repo = "neovim-qt";
      rev = "e7a51dd58a4a10147d34e93d20b19eeeffc69814";
      sha256 = "/EbLrJwMd2brclvJWMniwtexY5VURCGUUTjLV/FqE7o=";
    };
  });
}
