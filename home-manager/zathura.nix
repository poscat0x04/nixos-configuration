{ ... }:

{
  programs.zathura.options = {
    synctex = true;
    synctex-editor-command = "nvim +%{line} %{input}";
  };
}
