{ pkgs, ... }:

{
  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-rime
      fcitx5-material-color
      fcitx5-table-extra
      fcitx5-table-other
      fcitx5-chinese-addons
    ];
  };
}
