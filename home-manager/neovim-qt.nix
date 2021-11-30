{ ... }:

{
  xdg.configFile."nvim/ginit.vim".text = ''
    GuiFont monospace:h12
    GuiScrollBar 1
    call GuiClipboard()

    nnoremap <silent><RightMouse> :call GuiShowContextMenu()<CR>
    inoremap <silent><RightMouse> <Esc>:call GuiShowContextMenu()<CR>
    xnoremap <silent><RightMouse> :call GuiShowContextMenu()<CR>gv
    snoremap <silent><RightMouse> <C-G>:call GuiShowContextMenu()<CR>gv
  '';
}
