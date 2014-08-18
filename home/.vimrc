" Forgo vi compatibility
set nocompatible

" Detect operating system
let s:is_windows = has("win32") || has("win64")
let s:is_unix = (!s:is_windows) || has("win32unix")
if s:is_unix
  let s:uname = split(system('uname'))[0]
  let s:is_osx = s:uname =~? "Darwin"
else
  let s:is_osx = 0
endif

" Allow backspacing over everything in insert mode
set backspace=indent,eol,start

set backup
set backupcopy=yes

set history=100
set ruler
set showcmd
set incsearch
set hlsearch

" Used enhanced Ex-mode
map Q gQ

" Switch syntax highlighting on, when the terminal has colors
if &t_Co > 2 || has("gui_running")
  syntax on
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

  augroup END

endif " has("autocmd")


"
" End of section based on the example .vimrc file
"


""" General preference settings

set autoindent
set hidden
set laststatus=2
set encoding=utf-8
set nojoinspaces
set printoptions=paper:letter
set cursorline
set list
set listchars=trail:▫,tab:‣\ 


""" Tab setting commands

command Twotab setlocal tabstop=2 shiftwidth=2 expandtab smarttab
command Threetab setlocal tabstop=3 shiftwidth=3 expandtab smarttab
command Threerealtab setlocal tabstop=3 shiftwidth=3 noexpandtab smarttab
command Fourtab setlocal tabstop=4 shiftwidth=4 expandtab smarttab
command Fourrealtab setlocal tabstop=4 shiftwidth=4 noexpandtab
command Eightrealtab setlocal tabstop=8 shiftwidth=8 noexpandtab


""" Good for lisp-like languages
command HyphenatedKeywords setlocal iskeyword=@,48-57,_,-,192-255


""" Print to Preview on OS X
if s:is_osx

  set printexpr=PrintPreview(v:fname_in)
  function PrintPreview(fname)
    call system('open -a Preview '. a:fname . '; rm ' . a:fname)
    return v:shell_error
  endfunc

endif " s:is_osx


""" Filetype-specific settings

" Python
au FileType python Fourtab

" HTML
au FileType html Twotab
au FileType xhtml Twotab

" XML
au FileType xml Fourtab
au FileType xml syntax on
let g:xml_syntax_folding=1
au FileType xml setlocal foldmethod=syntax

" Vim script
au FileType vim Twotab

" SWIG
au BufNewFile,BufRead *.i set filetype=swig

" Go
au BufRead,BufNewFile *.go set filetype=go


""" Simple text highlighting

function SimpleHighlightSyntax()
  syn clear
  syn keyword simpleTodo TODO FIXME XXX REF CHECK
  syn keyword simpleTodo2 contained TODO FIXME XXX REF CHECK
  syn match simpleCite "\\cite{[^}]*}"
  syn match simpleCite2 contained "\\cite{[^}]*}"
  syn match simpleComment "^#.*" contains=simpleTodo2,simpleCite2
  hi def link simpleComment Comment
  hi def link simpleTodo Todo
  hi def link simpleTodo2 Todo
  hi def link simpleCite Type
  hi def link simpleCite2 Type
endfunction
command SimpleHighlight call SimpleHighlightSyntax()
au FileType simple call SimpleHighlightSyntax()


""" Abbreviations
iabbrev umgr Micro-Manager
iabbrev hcw Hardware Configuration Wizard
iabbrev dpb Device Property Browser
iabbrev probrep Problem Report (Help Menu)
