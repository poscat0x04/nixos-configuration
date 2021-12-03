{ pkgs, ... }:

let
  cfg = {
    verbatimEnvironments.nameAsRegex = {
      name = "\\w+code\\*?";
      lookForThis = 1;
    };
    removeTrailingWhitespace = 1;
    indentRules.item = "  ";
    modifyLineBreaks.items.ItemFinishesWithLineBreak = 1;
  };
  settings-yaml = pkgs.writeText "settings.yaml" ''
    verbatimEnvironments:
      nameAsRegex:
        name: '\w+code\*?'
        lookForThis: 1

    removeTrailingWhitespace: 1

    defaultIndent: '  '

    #logFilePreferences:
    #  showAmalgamatedSettings: 1

    indentRules:
      item: '  '

    modifyLineBreaks:
      items:
        ItemFinishesWithLineBreak: 1
  '';
  indentconfig = ''
    paths:
      - "${settings-yaml}"
  '';
  latexmkrc = ''
    $pdf_mode = 5;

    $compiling_cmd = "nvim --remote-expr 'vimtex#compiler#callback(2)'";
    $success_cmd = "nvim --remote-expr 'vimtex#compiler#callback(1)'";
    $failure_cmd = "nvim --remote-expr 'vimtex#compiler#callback(0)'";
  '';
in {
  home.file = {
    ".indentconfig.yaml".text = indentconfig;
    ".latexmkrc".text = latexmkrc;
  };
}
