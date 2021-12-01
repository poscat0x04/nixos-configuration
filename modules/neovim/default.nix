{ pkgs, ... }:

let
  vimtex-pr = pkgs.vimUtils.buildVimPlugin {
    name = "vimtex-pr";
    src = pkgs.fetchFromGitHub {
      owner = "poscat0x04";
      repo = "vimtex";
      rev = "7304a4e146c952b8a5c2e2566d25adf1480debd3";
      sha256 = "lguSzFkQsTsMEg5VG8hkRjsTGO3cvGh/BilS0lI8Oms=";
      fetchSubmodules = true;
    };
  };
in
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
        let g:vimtex_compiler_method = 'latexmk'
        let g:vimtex_compiler_latexmk = {
        \ 'build_dir': 'output',
        \ 'callback': 1,
        \ 'continuous': 1,
        \ 'options' : [
        \   '-shell-escape',
        \   '-synctex=1',
        \   '-file-line-error',
        \   '-interaction=nonstopmode',
        \ ],
        \}
        let g:vimtex_view_method = 'zathura'
        let g:vimtex_callback_progpath = "/run/current-system/sw/bin/nvim"

        let g:UltiSnipsExpandTrigger="<tab>"
        let g:UltiSnipsJumpForwardTrigger="<tab>"
        let g:UltiSnipsJumpBackwardTrigger="<s-tab>"

        let g:UltiSnipsSnippetDirectories = ["${./snippets}"]
        let g:UltiSnipsSnippetStorageDirectoryForUltiSnipsEdit = $HOME . "/Projects/Nix/nixos-configuration/modules/neovim/snippets"

        let g:lightline = {
          \ 'colorscheme': 'nord',
          \ }

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

        syntax on
        let g:nord_cursor_line_number_background = 1
        let g:nord_uniform_diff_background = 1
        let g:nord_italic = 1
        let g:nord_italic_comments = 1
        let g:nord_underline = 1

        augroup nord-overrides
          autocmd!
          autocmd ColorScheme nord highlight Comment ctermfg=14
        augroup END
        colorscheme nord

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
                    "-l",
                    "--curft=/tmp/"
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
        let g:ale_tex_chktex_options = '-I -wall -n22 -n30 -e16 -n3'

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
          vimtex-pr
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
        ];
        opt = [ ];
      };
    };
  };

  environment.systemPackages = with pkgs; [ universal-ctags xdotool xclip ];
}
