{ pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    vimAlias = true;
    viAlias = true;
    defaultEditor = true;
    configure = {
      customRC = ''
        let g:deoplete#enable_at_startup = 1
        call deoplete#custom#var('omni', 'input_patterns', {
                \ 'tex': g:vimtex#re#deoplete
                \})
        call deoplete#custom#option({
                \ 'smart_case': v:true,
                \})

        let g:tex_flavor = 'latex'
        let g:vimtex_fold_enabled = 1
        let g:vimtex_compiler_method = 'latexmk'
        let g:vimtex_compiler_latexmk = {
        \ 'build_dir': 'output',
        \ 'callback': 1,
        \ 'continuous': 0,
        \ 'options' : [
        \   '-synctex=1',
        \   '-file-line-error',
        \   '-interaction=nonstopmode',
        \ ],
        \}
        let g:vimtex_view_method = 'zathura'
        let g:vimtex_callback_progpath = "/run/current-system/sw/bin/nvim"

        augroup existsu_syntax_hack
          au!
          au User VimtexEventInitPost syntax match texMathCmdCExist /\v\\exists?/ contained conceal cchar=∃ contains=texMathCmdCExistUnique nextgroup=texMathCmdCExistUnique
          au User VimtexEventInitPost highlight def link texMathCmdCExist texMathCmd
          au User VimtexEventInitPost syntax cluster texClusterMath add=texMathCmdCExist
          au User VimtexEventInitPost syntax match texMathCmdCExistUnique /\v(U|u)/ contained conceal cchar=!
          au User VimtexEventInitPost highlight def link texMathCmdCExistUnique texMathCmd
        augroup END

        let g:vimtex_syntax_custom_cmds = [
        \ {'name': 'emph', 'mathmode': 0, 'conceal': 1, 'argstyle': 'bold'},
        \ {'name': 'Emph', 'mathmode': 0, 'conceal': 1, 'argstyle': 'bold'},
        \ {'name': 'N',                        'mathmode': 1, 'concealchar': 'ℕ'},
        \ {'name': 'Z',                        'mathmode': 1, 'concealchar': 'ℤ'},
        \ {'name': 'Q',                        'mathmode': 1, 'concealchar': 'ℚ'},
        \ {'name': 'R',                        'mathmode': 1, 'concealchar': 'ℝ'},
        \ {'name': 'C',                        'mathmode': 1, 'concealchar': 'ℂ'},
        \ {'name': 'H',                        'mathmode': 1, 'concealchar': 'ℍ'},
        \ {'name': 'O',                        'mathmode': 1, 'concealchar': '𝕆'},
        \ {'name': 'F',                        'mathmode': 1, 'concealchar': '𝔽'},
        \ {'name': 'WS',     'cmdre': '\ ',    'mathmode': 0, 'concealchar': ' '},
        \ {'name': 'WS',     'cmdre': '\ ',    'mathmode': 1, 'concealchar': ' '},
        \ {'name': 'LCBra',  'cmdre': '\{',    'mathmode': 1, 'concealchar': '{'},
        \ {'name': 'RCBra',  'cmdre': '\}',    'mathmode': 1, 'concealchar': '}'},
        \ {'name': 'LParen', 'cmdre': '\(',    'mathmode': 1, 'concealchar': '('},
        \ {'name': 'RParen', 'cmdre': '\)',    'mathmode': 1, 'concealchar': ')'},
        \ {'name': 'LBra',   'cmdre': '\[',    'mathmode': 1, 'concealchar': '['},
        \ {'name': 'RBra',   'cmdre': '\]',    'mathmode': 1, 'concealchar': ']'},
        \ {'name': 'LDotP',  'cmdre': 'ldotp', 'mathmode': 1, 'concealchar': '.'},
        \]
        autocmd BufWritePost *.tex call vimtex#compiler#compile()
        autocmd User VimtexEventCompileSuccess call vimtex#view#view()

        let g:UltiSnipsEditSplit = "vertical"
        let g:UltiSnipsEnableSnipMate = 0
        let g:UltiSnipsExpandTrigger="<tab>"
        let g:UltiSnipsJumpForwardTrigger="<tab>"
        let g:UltiSnipsJumpBackwardTrigger="<s-tab>"

        let g:UltiSnipsSnippetDirectories = [ "${./snippets}" ]
        let g:UltiSnipsSnippetStorageDirectoryForUltiSnipsEdit = $HOME . "/Projects/Nix/nixos-configuration/modules/neovim/snippets"

        let g:lightline = {
          \ 'colorscheme': 'nord',
          \ }

        set conceallevel=2
        set concealcursor=c

        set tabstop=8 softtabstop=0 expandtab shiftwidth=2 smarttab
        set mouse=a
        set nu
        set nocompatible
        set showcmd
        set showmode
        set nobackup
        set nowritebackup

        setlocal spell
        set spelllang=en_us
        inoremap <C-l> <c-g>u<Esc>[s1z=`]a<c-g>u

        inoremap <C-e> <Esc>$a

        augroup remember_folds
          autocmd!
          autocmd BufWinLeave * mkview
          autocmd BufWinEnter * silent! loadview
        augroup END

        syntax on
        let g:nord_cursor_line_number_background = 1
        let g:nord_uniform_diff_background = 1
        let g:nord_italic = 1
        let g:nord_italic_comments = 1
        let g:nord_underline = 1

        augroup nord-overrides
          autocmd!
          autocmd ColorScheme nord highlight Comment ctermfg=14
          autocmd ColorScheme nord highlight Folded ctermfg=12 cterm=NONE guifg=#586885
          autocmd ColorScheme nord highlight helpHyperTextJump guisp=#88C0D0
        augroup END
        colorscheme nord

        function! SynStack()
          if !exists("*synstack")
            return
          endif
          echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
        endfunc

        let g:lastplace_ignore = "gitcommit"
        let g:lastplace_ignore_buftype = "quickfix,nofile,help"

        let g:LanguageClient_serverCommands = {
          \ 'rust': ['rust-analyzer'],
          \ 'dhall': ['dhall-lsp-server'],
          \ 'haskell': ['haskell-language-server', '--lsp'],
          \ 'purescript': ['purs', 'ide', 'server'],
          \ 'nix': ['rnix-lsp']
          \ }

        nnoremap <F5> :call LanguageClient_contextMenu()<CR>
        map <Leader>lk :call LanguageClient#textDocument_hover()<CR>
        map <Leader>lg :call LanguageClient#textDocument_definition()<CR>
        map <Leader>lr :call LanguageClient#textDocument_rename()<CR>
        map <Leader>lf :call LanguageClient#textDocument_formatting()<CR>
        map <Leader>lb :call LanguageClient#textDocument_references()<CR>
        map <Leader>la :call LanguageClient#textDocument_codeAction()<CR>
        map <Leader>ls :call LanguageClient#textDocument_documentSymbol()<CR>

        lua << EOF
        require('formatter').setup({
          filetype = {
            tex = {
              function ()
                return {
                  exe = "latexindent",
                  args = {
                    "\"-y=defaultIndent: '  '\"",
                    "-m",
                    "-l",
                    "--cruft=/tmp/"
                  },
                  stdin = true
                }
              end
            },
          }
        })
        EOF

        nnoremap <silent> <leader>f :Format<CR>
        augroup FormatAutogroup
          autocmd!
          autocmd BufWritePost *.tex,*.bib,*.cls,*.sty FormatWrite
        augroup END

        let g:ale_disable_lsp = 1
        let g:ale_linters = {'tex': ['chktex'], 'nix': []}
        let g:ale_tex_chktex_options = '-I -wall -n21 -n22 -n30 -e16 -n3'
        let g:ale_virtualtext_cursor = 1

        let g:gutentags_project_root = [ ".project" ]
        let g:gutentags_cache_dir = "~/.cache/gutentags"

        imap <S-Insert> <C-R>*
        set clipboard+=unnamedplus

        autocmd VimEnter * if argc() == 0 && !exists("s:std_in") && v:this_session == "" && !&readonly| NERDTree | endif
        autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
        map <C-n> :NERDTreeToggle<CR>

        let g:fcitx5_remote = "fcitx5-remote"

        let g:better_whitespace_enabled=1
        let g:strip_whitespace_on_save = 1
        let g:strip_whitespace_confirm=0
        let mapleader = "\\"
        let maplocalleader = ","
      '';
      packages.myVimPackage = with pkgs.vimPlugins; {
        start = [
          vimtex
          LanguageClient-neovim
          dhall-vim
          nord-vim
          vimshell
          vim-yaml
          vim-nix
          vim-lastplace
          purescript-vim
          deoplete-nvim
          lightline-vim
          ats-vim
          nerdtree
          ultisnips
          vim-plugin-AnsiEsc
          vim-better-whitespace
          vim-toml
          idris2-vim
          fcitx-vim
          formatter-nvim
          ale
          vim-gutentags
          fzf-vim
        ];
        opt = [ ];
      };
    };
  };

  environment.systemPackages = with pkgs; [ universal-ctags xdotool xclip ];
}
