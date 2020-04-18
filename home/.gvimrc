" MacVim starts with 'macvim' color scheme, which is hard to read in dark
" mode.
" MacVim seems to set up color schemes after gvimrc is sourced, so just
" executing 'colorscheme default' here results in something different.
" See also :help macvim-colorscheme
autocmd GUIEnter * colorscheme default

if has("gui_macvim")
  " One point larger than default
  set guifont=Menlo-Regular:h12
endif
