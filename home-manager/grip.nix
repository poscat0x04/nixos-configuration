{ secrets, ... }:

{
  xdg.configFile."grip/settings.py".text = ''
    PASSWORD = 'secrets.github-token-grip'
  '';
}
