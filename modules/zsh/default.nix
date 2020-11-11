{ config, pkgs, lib, ... }:

with builtins; with lib;

let
  modify-commands = modifier: commands: map (command: {
    fst = command;
    snd = "${modifier} ${command}";
  }) commands;
  disable-correction-commands = [
    "ack"
    "cd"
    "cp"
    "gcc"
    "grep"
    "ln"
    "man"
    "mkdir"
    "mv"
    "rm"
  ];
  disable-globbing-commands = [
    "find"
    "history"
    "locate"
    "rsync"
    "scp"
    "sftp"
  ];
  disable-correction = modify-commands "nocorrect" disable-correction-commands;
  disable-globbing = modify-commands "noglob" disable-globbing-commands;
  general-aliases = [
    { fst = "diffu"; snd = "diff --unified"; }
    { fst = "_"; snd = "sudo"; }
  ];
  aliases = disable-correction ++ disable-globbing ++ general-aliases;
  aliasesStr = concatMapStringsSep "\n" (alias: "alias ${alias.fst}=${escapeShellArg alias.snd}") aliases;

  custom-aliases = {
    l = "ls -1A";
    ll = "ls -lh";
    lr = "ll -R";
    la = "ll -A";
    lm = "la | \"$PAGER\"";
    lx = "ll -XB";
    lk = "ll -Sr";
    lt = "ll -tr";
    lc = "ll -c";
    lu = "lt -u";
    sl = "ls";
    o = "xdg-open";
    get = "curl --continue-at - --location --progress-bar --remote-name --remote-time";
    df = "df -kh";
    du = "du -kh";

    history-stat = "history 0 | awk '{print $2}' | sort | uniq -c | sort -n -r | head";

    fs = "nix-env -f '<nixpkgs>' -qaP -A";
    cb = "cabal build --ghc-options='-Wall -fno-warn-unused-do-bind'";
    ct = "cabal new-test --test-show-details=streaming --disable-documentation";
    pb = "curl -F 'c=@-' 'https://fars.ee/'";
  };
in

{
  environment.systemPackages = with pkgs; [
    nix-index
    zsh-completions
  ];

  programs = {
    command-not-found.enable = false;

    zsh = {
      enable = true;
      histSize = 10000;

      setOptions = [
        "auto_cd"
        "auto_pushd"
        "pushd_ignore_dups"
        "pushd_silent"
        "pushd_to_home"
        "cdable_vars"
        "multios"
        "extended_glob"

        "combining_chars"
        "interactive_comments"
        "rc_quotes"

        "long_list_jobs"
        "auto_resume"
        "notify"

        "complete_in_word"
        "always_to_end"
        "path_dirs"
        "auto_menu"
        "auto_list"
        "auto_param_slash"

        "correct"

        "bang_hist"
        "extended_history"
        "share_history"
        "hist_expire_dups_first"
        "hist_ignore_dups"
        "hist_ignore_all_dups"
        "hist_ignore_space"
        "hist_save_no_dups"
        "hist_verify"
        "hist_beep"
      ];

      interactiveShellInit = let
        system = "nixosConfigurations.${config.networking.hostName}";
      in lib.mkOrder 2000 (''
        unsetopt clobber

        unsetopt mail_warning

        unsetopt bg_nice
        unsetopt hup
        unsetopt check_jobs

        unsetopt menu_complete
        unsetopt flow_control

        ${aliasesStr}
        for index ({1..9}) alias "$index"="cd +''${index}"; unset index

        alias grep="''${aliases[grep]:-grep} --color=auto"
        alias mkdir="''${aliases[mkdir]:-mkdir} -p"
        alias rm="''${aliases[rm]:-rm} -i"
        alias mv="''${aliases[mv]:-mv} -i"
        alias cp="''${aliases[cp]:-cp} -i"
        alias ln="''${aliases[ln]:-ln} -i"
        alias ls="''${aliases[ls]:-ls} --color=auto"

        eval $(dircolors ${pkgs.extra-files.nord-dircolors})

      '' + (readFile ./completion.zsh) +
      ''

        ZSH_AUTOSUGGEST_USE_ASYNC=1

        bindkey -v

        #
        # Variables
        #

        # Treat these characters as part of a word.
        WORDCHARS='*?_-.[]~&;!#$%^(){}<>'

        # Use human-friendly identifiers.
        zmodload zsh/terminfo
        typeset -gA key_info
        key_info=(
          'Control'         '\C-'
          'ControlLeft'     '\e[1;5D \e[5D \e\e[D \eOd'
          'ControlRight'    '\e[1;5C \e[5C \e\e[C \eOc'
          'ControlPageUp'   '\e[5;5~'
          'ControlPageDown' '\e[6;5~'
          'Escape'       '\e'
          'Meta'         '\M-'
          'Backspace'    "^?"
          'Delete'       "^[[3~"
          'F1'           "$terminfo[kf1]"
          'F2'           "$terminfo[kf2]"
          'F3'           "$terminfo[kf3]"
          'F4'           "$terminfo[kf4]"
          'F5'           "$terminfo[kf5]"
          'F6'           "$terminfo[kf6]"
          'F7'           "$terminfo[kf7]"
          'F8'           "$terminfo[kf8]"
          'F9'           "$terminfo[kf9]"
          'F10'          "$terminfo[kf10]"
          'F11'          "$terminfo[kf11]"
          'F12'          "$terminfo[kf12]"
          'Insert'       "$terminfo[kich1]"
          'Home'         "$terminfo[khome]"
          'PageUp'       "$terminfo[kpp]"
          'End'          "$terminfo[kend]"
          'PageDown'     "$terminfo[knp]"
          'Up'           "$terminfo[kcuu1]"
          'Left'         "$terminfo[kcub1]"
          'Down'         "$terminfo[kcud1]"
          'Right'        "$terminfo[kcuf1]"
          'BackTab'      "$terminfo[kcbt]"
        )

        # Set empty $key_info values to an invalid UTF-8 sequence to induce silent
        # bindkey failure.
        for key in "''${(k)key_info[@]}"; do
          if [[ -z "$key_info[$key]" ]]; then
            key_info[$key]='�'
          fi
        done

        ${readFile ./terminal.zsh}

        source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
        source ${./p10k.zsh}

        source ${pkgs.zsh-history-substring-search}/share/zsh-history-substring-search/zsh-history-substring-search.zsh

        for keymap in 'emacs' 'viins'; do
          bindkey -M "$keymap" "$key_info[Up]" history-substring-search-up
          bindkey -M "$keymap" "$key_info[Down]" history-substring-search-down
        done

        fpath=(${./functions} $fpath)
        autoload -U archive lsarchive unarchive
        autoload -U compinit && compinit -u

        source ${pkgs.nix-index}/etc/profile.d/command-not-found.sh

        nixos-option () {
          local flakePath="${./../..}"
          local option

          if [ ! -z "$2" ]; then
            flakePath="$1"
            shift
          fi

          option="$1"
          shift

          nix eval "$@" "$flakePath#${system}.config.$option"
        }

        export SSH_AUTH_SOCK=$XDG_RUNTIME_DIR/gnupg/S.gpg-agent.ssh
        export SSH_AGENT_PID=

        if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
          source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
        fi
      '');
      shellAliases = mkForce custom-aliases;
      autosuggestions = {
        enable = true;
        highlightStyle = "fg=#9e9e9e";
      };
      enableGlobalCompInit = false;
      syntaxHighlighting = {
        enable = true;
        highlighters = [
          "main"
          "brackets"
        ];
      };
    };
  };
}
