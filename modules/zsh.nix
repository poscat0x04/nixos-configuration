{ config, pkgs, ... }:

{
  programs = {
    command-not-found.enable = false;

    zsh = {
      enable = true;
      interactiveShellInit = let
        system = "nixosConfigurations.${config.networking.hostName}";
      in ''
        source ${pkgs.nix-index}/etc/profile.d/command-not-found.sh

        nixos-option () {
          local flakePath="${./..}"
          local option

          if [ ! -z "$2" ]; then
            flakePath="$1"
            shift
          fi

          option="$1"
          shift

          nix eval "$@" "$flakePath#${system}.config.$option"
        }
 
        source ${pkgs.zsh-prezto}/init.zsh
        export SSH_AUTH_SOCK=$XDG_RUNTIME_DIR/gnupg/S.gpg-agent.ssh
        export SSH_AGENT_PID=
        if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
          source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
        fi

        # To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
        [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
      '';
      shellAliases = {
        cb = "cabal build --ghc-options='-Wall -fno-warn-unused-do-bind'";
        ct = "cabal new-test --test-show-details=streaming --disable-documentation";
        pb = "curl -F 'c=@-' 'https://fars.ee/'";
      };
    };
  };
}
