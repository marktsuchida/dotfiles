"
" First section of this file based on vimrc_example.vim
"

source $VIMRUNTIME/defaults.vim

set backup
set backupcopy=yes
if has('persistent_undo')
  set undofile
endif

if &t_Co > 2 || has("gui_running")
  " Switch on highlighting the last used search pattern.
  set hlsearch
endif

if has("autocmd")
  autocmd FileType text setlocal textwidth=78
else
  set autoindent
endif " has("autocmd")

if has('syntax') && has('eval')
  packadd! matchit
endif

"
" End of section based on the example .vimrc file
"


" Detect operating system
let s:is_windows = has("win32") || has("win64")
let s:is_unix = (!s:is_windows) || has("win32unix")
if s:is_unix
  let s:uname = split(system('uname'))[0]
  let s:is_osx = s:uname =~? "Darwin"
else
  let s:is_osx = 0
endif


""" General preference settings

set hidden
set laststatus=2
set encoding=utf-8
set nojoinspaces
set printoptions=paper:letter
set cursorline
set colorcolumn=81,133
highlight ColorColumn term=bold ctermbg=4 guibg=darkgrey
set list
set listchars=trail:▫,tab:‣\ 
set scrolloff=1


""" Man command
runtime! ftplugin/man.vim
set keywordprg=:Man


""" Japanese input
" fo m = word break at any character above 255
" fo B = join lines without inserting space for any mb char
command Jpn setlocal formatoptions+=mB nospell


""" Edit text without newlines
command FlowText setlocal spell wrap linebreak nolist textwidth=0 wrapmargin=0


""" Tab setting commands

command Twotab setlocal tabstop=2 shiftwidth=2 expandtab smarttab
command Threetab setlocal tabstop=3 shiftwidth=3 expandtab smarttab
command Fourtab setlocal tabstop=4 shiftwidth=4 expandtab smarttab
command Eighttab setlocal tabstop=8 shiftwidth=8 expandtab smarttab

command Realtwotab setlocal tabstop=2 shiftwidth=2 noexpandtab
command Realthreetab setlocal tabstop=3 shiftwidth=3 noexpandtab
command Realfourtab setlocal tabstop=4 shiftwidth=4 noexpandtab
command Realeighttab setlocal tabstop=8 shiftwidth=8 noexpandtab


""" Good for lisp-like languages
command HyphenatedKeywords setlocal iskeyword=@,48-57,_,-,192-255


""" OS X copy & paste
if s:is_osx

  command -range Copy <line1>,<line2>w !/usr/local/bin/reattach-to-user-namespace pbcopy
  command Paste call OSXPaste()
  function OSXPaste()
    let oldpaste=&paste
    r !/usr/local/bin/reattach-to-user-namespace pbpaste
    let &paste=oldpaste
    unlet oldpaste
  endfunction

endif " s:is_osx


""" Print to Preview on OS X
if s:is_osx

  set printexpr=PrintPreview(v:fname_in)
  function PrintPreview(fname)
    call system('open -a Preview '. a:fname . '; rm ' . a:fname)
    return v:shell_error
  endfunc

endif " s:is_osx


""" Preview in Marked 2 on OS X
if s:is_osx
  command Marked !open -a Marked\ 2.app '%:p'
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

" YAML
au FileType yaml Twotab

" BeanShell
au BufRead,BufNewFile *.bsh set filetype=java
au BufRead,BufNewFile *.bsh Realthreetab

" TypeScript
au BufRead,BufNewFile *.ts set filetype=javascript
au BufRead,BufNewFile *.ts Twotab


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
