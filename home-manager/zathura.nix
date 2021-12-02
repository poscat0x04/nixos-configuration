{ ... }:

{
  programs.zathura = {
    enable = true;
    options = {
      database = "sqlite";
      window-height = "2000";
      window-width = "2400";
      synctex = true;
    };
  };
}
