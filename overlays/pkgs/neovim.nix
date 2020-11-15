self: super:
rec {
  customized-neovim = super.pkgs.neovim.override {
    configure = {
      customRC = ''
        let g:deoplete#enable_at_startup = 1
        let g:vimtex_compiler_progname = 'nvr'
        let g:tex_flavor = 'latex'

        let g:lightline = {
          \ 'colorscheme': 'nord',
          \ }

        set tabstop=8 softtabstop=0 expandtab shiftwidth=2 smarttab
        set mouse=a
        set nu
        set nocompatible
        set showcmd
        set showmode

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
          \ 'dhall' : ['dhall-lsp-server'],
          \ 'purescript' : ['purs', 'ide', 'server']
          \ }

        nnoremap <F5> :call LanguageClient_contextMenu()<CR>
        map <Leader>lk :call LanguageClient#textDocument_hover()<CR>
        map <Leader>lg :call LanguageClient#textDocument_definition()<CR>
        map <Leader>lr :call LanguageClient#textDocument_rename()<CR>
        map <Leader>lf :call LanguageClient#textDocument_formatting()<CR>
        map <Leader>lb :call LanguageClient#textDocument_references()<CR>
        map <Leader>la :call LanguageClient#textDocument_codeAction()<CR>
        map <Leader>ls :call LanguageClient#textDocument_documentSymbol()<CR>

        imap <S-Insert> <C-R>*
        set clipboard=unnamedplus

        autocmd VimEnter * if argc() == 0 && !exists("s:std_in") && v:this_session == "" && !&readonly| NERDTree | endif
        autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
        map <C-n> :NERDTreeToggle<CR>

        let g:UltiSnipsExpandTrigger="<tab>"
        let g:UltiSnipsJumpForwardTrigger="<tab>"
        let g:UltiSnipsJumpBackwardTrigger="<s-tab>"

      '';
      packages.myVimPackage = with super.pkgs.vimPlugins; {
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
        ];
        opt = [ ];
      };
    };
  };

  customized-neovim-qt = super.pkgs.neovim-qt.override {
    neovim = customized-neovim;
  };
}
