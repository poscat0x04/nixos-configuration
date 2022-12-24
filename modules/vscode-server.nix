{ flakes, ... }:

{
  imports = [ flakes.vscode-server.nixosModules.default ];

  services.vscode-server.enable = true;
}
