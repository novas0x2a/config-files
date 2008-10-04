scriptencoding utf-8

set nocompatible                    " Yay ViM!

let g:inkpot_black_background = 1
set background=dark                 " Well, it /is/ dark...
colorscheme inkpot                  " My colorscheme's better

set backspace=indent,eol,start      " Backspace can eat anything
set expandtab                       " Use spaces, not tabs.
set tabstop=4                       " Tabs are 4 spaces
set shiftwidth=4                    " Indent is 4 spaces
set smarttab                        " Tab goes to the next tab stop
set nowrap                          " The wrapping behavior is annoying
set showmatch                       " Point out matched parens
set matchtime=2                     " Show match for 0.2 sec
set scrolloff=10                    " Context lines around cursor
set title                           " Set X11 terminal title
set linebreak                       " Break lines in a polite fashion
set autoindent                      " Use previous line's indentation
set cindent                         "    And augment it with c-style indentation
set nodigraph                       " No. I typo 1<BS>2 too much.
set ruler                           " Show line/column number
set wildmenu                        " Show a menu for cmdline completion
set wildmode=list:longest           "    And make it behave like the shell
set laststatus=2                    " Always show a status line
set shortmess=atIO                  " Get rid of most messages
set pastetoggle=<f11>               " hit f11 to paste
set nohlsearch                      " highlighting search hits is annoying
set history=100                     " remember 100 cmds
set showcmd                         " show typed command in progress
set suffixes+=.info,.aux,.log,.dvi,.bbl,.out " ignore tex intermediates for menu
set autowrite                       " Autosave on some buffer-switching ops
set autoread                        " Re-read changed file when safe
set incsearch                       " Incremental search
set formatoptions+=n                " Recognize numbered lists
set formatlistpat=^\\s*\\(\\d\\\|[-*]\\)\\+[\\]:.)}\\t\ ]\\s* "and bullets, too
set grepprg=grep\ -nH\ $*           " Always show filename for grep
set numberwidth=3                   " 3-digit line numbers
set viminfo+=!                      " Store upper-case registers in viminfo
set updatetime=2000                 " Wait before triggering CursorHold event
set switchbuf=usetab                " Try to switch to an open tab
set showtabline=1                   " Show tab line if more than one tab open
set lazyredraw                      " Delay redrawing the screen
set novisualbell                    " Don't you dare flash the screen
set t_vb=                           "   No, really, I'll hurt you if you do.
set noerrorbells                    " And don't bell me with errors, either
set nomore                          " Display all of the message at once
set secure                          " Turn on vimrc security
set exrc                            "   ... and allow local-directory vimrcs
set completeopt=longest,menuone,preview " Make code-completion spiffy
set path+=/usr/local/include        " local should be in the default path

" Force 16-colors where sane
"if &t_Co < 16 && (&term =~ "xterm*" || &term == "screen")
"    set t_Co=16
"endif

if &term ==? "xterm"
    set t_Sb=^[4%dm
    set t_Sf=^[3%dm
    set ttymouse=xterm2
endif

if &t_Co > 2 || has("gui_running")
    syntax on
endif

" Set taglist up properly
let Tlist_Compact_Format    = 1
let Tlist_Display_Prototype = 0
let Tlist_Exit_OnlyWindow   = 1
let Tlist_Sort_Type         = "name"
let Tlist_Use_Right_Window  = 1
let Tlist_Use_SingleClick   = 1
let Tlist_WinWidth          = 40

" Open netrw file in new tab
let g:netrw_browse_split    = 3

" Syntax highlighting tweaks
let perl_extended_vars = 1
let perl_string_as_statement = 1
let html_number_lines = 0
let html_use_css = 1
let is_bash=1
let python_highlight_all = 1

" Misc tweaks
let g:SuperTabLongestHighlight = 1
let g:compiler_gcc_ignore_unmatched_lines = 1
let g:alternateRelativeFiles = 1

" If we have a BOM, always honour that rather than trying to guess.
if &fileencodings !~? "ucs-bom"
  set fileencodings^=ucs-bom
endif

" Always check for UTF-8 when trying to determine encodings.
if &fileencodings !~? "utf-8"
  set fileencodings+=utf-8
endif

" Use international fonts where necessary
if v:lang =~? "^ko"
  set fileencodings=euc-kr
  set guifontset=-*-*-medium-r-normal--16-*-*-*-*-*-*-*
elseif v:lang =~? "^ja_JP"
  set fileencodings=euc-jp
  set guifontset=-misc-fixed-medium-r-normal--14-*-*-*-*-*-*-*
elseif v:lang =~? "^zh_TW"
  set fileencodings=big5
  set guifontset=-sony-fixed-medium-r-normal--16-150-75-75-c-80-iso8859-1,-taipei-fixed-medium-r-normal--16-150-75-75-c-160-big5-0
elseif v:lang =~? "^zh_CN"
  set fileencodings=gb2312
  set guifontset=*-r-*
endif

if v:lang =~ "utf8$" || v:lang =~ "UTF-8$"
  set fileencodings=utf-8,latin1
endif
set fileencodings+=default

let &termencoding = &encoding
set encoding=utf-8

so $VIMRUNTIME/ftplugin/man.vim

filetype plugin indent on

if 0 && (&termencoding == "utf-8") || has("gui_running") && ! has("gui_win32")
    set list listchars=tab:→·,trail:·,extends:⋯
else
    set list listchars=tab:>-,trail:.,extends:>
endif

map  <F3>  n
nmap <F4>  gwapvap:s/\.  /\. /g<CR>
map  <F5>  :make! run<CR>
map  <F9>  :make!<CR>
map  <F12> :set list!<CR>
map <leader>ss :setlocal lazyredraw<CR>m`:%s/[\t ]\+$/<CR>``:setlocal nolazyredraw<CR>
map Q gq

command MakeHtml runtime! syntax/2html.vim

if "" == &shell
    if executable("/bin/zsh")
        set shell=/bin/zsh
    elseif executable("/bin/bash")
        set shell=/bin/bash
    elseif executable("/bin/sh")
        set shell=/bin/sh
    endif
endif

augroup NewFiles
  au!
  au BufNewFile *.h call ShieldHeader()
  au BufNewFile *.cgi setf perl
  au BufNewFile,BufReadPost *.hdf setf hdf
  au BufNewFile,BufReadPost *.cs  setf cs
augroup END

au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g`\"" | endif

augroup Filetype
  au!
  au FileType ebuild set ts=4 sw=4 noexpandtab
  au FileType cvs s,^,\r, | startinsert
  au FileType make set noexpandtab
  au FileType mail set tw=72 | setlocal spell
  au FileType html,xml,xhtml,xslt set nu shiftwidth=2 tabstop=2
  au FileType crontab set backupcopy=yes
  au FileType scheme set lispwords-=if | set lispwords+=define-macro | set sw=2 ts=2 | set makeprg=gosh-rl\ -l%
  au FileType tex call UpdateSpellFile() | call SetupTexSpell() | setlocal spell | set tw=80 | set makeprg=latexmk\ -pdf\ %< | map <F5> :call RunOnce("open %<.pdf", "%<.pdf")<CR>
  au FileType none call UpdateSpellFile()
  au FileType c,cpp compiler gcc
  au FileType java compiler javac
  "au FileType python call PythonSetup()
augroup END

"" This breaks vim's gz filter. D'oh
"if has("autocmd")
"  " vim -b : edit binary using xxd-format!
"  augroup Binary
"    au!
"    au BufReadPre *.bin,*.hex setlocal binary
"    au BufReadPost *
"          \ if &binary | exe "Hexmode" | endif
"    au BufWritePre *
"          \ if exists("b:editHex") && b:editHex && &binary |
"          \  exe "%!xxd -r" |
"          \ endif
"    au BufWritePost *
"          \ if exists("b:editHex") && b:editHex && &binary |
"          \  exe "%!xxd" |
"          \  exe "set nomod" |
"          \ endif
"  augroup END
"endif
"
command Hexmode call ToggleHex()

function ToggleHex()
    " hex mode should be considered a read-only operation
    " save values for modified and read-only for restoration later,
    " and clear the read-only flag for now
    let l:modified=&mod
    let l:oldreadonly=&readonly
    let &readonly=0
    if !exists("b:editHex") || !b:editHex
        " save old options
        let b:oldft=&ft
        let b:oldbin=&bin
        " set new options
        setlocal binary " make sure it overrides any textwidth, etc.
        let &ft="xxd"
        " set status
        let b:editHex=1
        " switch to hex editor
        %!xxd
    else
        " restore old options
        let &ft=b:oldft
        if !b:oldbin
            setlocal nobinary
        endif
        " set status
        let b:editHex=0
        " return to normal editing
        %!xxd -r
    endif
    " restore values for modified and read only state
    let &mod=l:modified
    let &readonly=l:oldreadonly
endfunction

" vim -b : edit binary using xxd-format!
augroup Binary
  au!
  au BufReadPre  *.bin let &bin=1
  au BufReadPost *.bin if &bin | %!xxd -g1 -u
  au BufReadPost *.bin set ft=xxd | endif
  au BufWritePre *.bin if &bin | %!xxd -r
  au BufWritePre *.bin endif
  au BufWritePost *.bin if &bin | %!xxd
  au BufWritePost *.bin set nomod | endif
augroup END

" Nice statusbar
set laststatus=2
set statusline=
set statusline+=%-3.3n\                      " buffer number
set statusline+=%f\                          " file name
set statusline+=%h%m%r%w                     " flags
set statusline+=\[%{strlen(&ft)?&ft:'none'}, " filetype
set statusline+=%{&encoding},                " encoding
set statusline+=%{&fileformat}]              " file format
set statusline+=%=                           " right align
set statusline+=%-14.(%l,%c%V%)\ %<%P        " offset

function! UpdateSpellFile()
    let localspell  = expand("~/.vim/spell/" . &spelllang . "." . &encoding . ".add")

    if filereadable(localspell)
        if getftime(localspell) > getftime(localspell . ".spl")
            exec "mkspell! " . localspell
        endif
    endif
endfunction

function! SetupTexSpell()
    let spellsuffix = &spelllang . "." . &encoding . ".add"
    let texspell    = expand("<afile>:p:h") . "/dict-" . expand("<afile>:t:r") . "." . spellsuffix
    let localspell  = expand("~/.vim/spell/" . spellsuffix)
    exec "set spellfile=" . localspell . "," . texspell
endfunction

function! SpellTexIgnoreWord(word)
    exec "2spellgood " . a:word
endfunction

function! RunOnce(cmd,key)
    exec ":!(" . a:cmd . ")&"
endfunction

function! ShieldHeader()
    let sym = toupper(substitute(expand("%:t"), "[^A-Za-z]", "_", "g"))
    let curpos = getpos(".")
    let curpos[1] = curpos[1]+3
    call append(0, ["#ifndef " . sym, "#define " . sym, "", ""])
    call append(line('$'), ["", "#endif"])
    call setpos('.', curpos)
endfunction

function! UniqInsert(str)
    if search(a:str, 'cw')
        call cursor(line(".")+1, 1)
    else
        if strlen(getline(line('$')))
            call append(line('$'), [a:str, ""])
        else
            call append(line('$')-1, [a:str])
        endif
        call cursor(line('$'), 1)
    endif
endfunction

function! NoteTime()
    " Round to nearest 1/2 hour
    let time = localtime() / (60*30) * 60*30
    let str  = strftime("  == %R ==", time)
    call UniqInsert(str)
endfunction

function! NoteDate()
    let time = strftime("===== %Y %B %d =====")
    call UniqInsert(time)
endfunction

au FileType notes call NoteDate() | call NoteTime() | au! FileType notes | startinsert

autocmd BufNewFile,BufRead COMMIT_EDITMSG set filetype=gitcommit

map <leader>y :YRShow<cr>

map <leader>tn :tabnew<cr>
map <leader>tc :tabclose<cr>
map <leader>tm :tabmove<space>
map <leader>te :tabedit<space>
map <leader>tf :tabfind<space>
map <leader>f :find<space>

map <C-Right>  :tabnext<cr>
map <C-Left>   :tabprev<cr>
imap <C-Right> <esc>:tabnext<cr>
imap <C-Left>  <esc>:tabprev<cr>

" These are for putty. Apparently, it screws up the arrow keys.
map [D :tabprev<cr>
map [C :tabnext<cr>
imap [D :tabprev<cr>
imap [C :tabnext<cr>

" RXVT...
map Od :tabprev<cr>
map Oc :tabnext<cr>
imap Od :tabprev<cr>
imap Oc :tabnext<cr>

nnoremap <silent> <leader>o :TlistToggle<CR>

nmap <leader>n :cn<cr>
nmap <leader>p :cp<cr>
nmap <leader>c :botright cw 10<cr>

nmap <leader>w :w<cr>
nmap <leader>q :q<cr>
nmap <leader>Q :qa<cr>

" Mouse is just annoying.
" set mouse+=a
" set selectmode=mouse

cno $h e ~/
cno $$ e ./
cno <expr>$d expand('%:p:h')

"map <Leader>h  :A<CR>
"map <Leader>sh :AV<CR>
function! PythonSetup()

set path=

python << EOF
import os
import sys
import vim
for p in sys.path:
    if os.path.isdir(p):
        vim.command(r"set path+=%s" % (p.replace(" ", r"\ ")))

    try:
        import settings
        from django.core.management import setup_environ
        setup_environ(settings)
        try:
            from django.db.models.loading import get_models
            get_models()
        except: pass

        import django
        for mod in ['bin', 'conf', 'contrib', 'core', 'db', 'dispatch', 'forms',  \
                    'http', 'middleware', 'shortcuts', 'template', 'templatetags',\
                    'test', 'utils', 'views']:
            try:
                __import__('django.' + mod, globals(), locals(), [], -1)
            except: pass

        #class Apps(object):
        #    def __init__(self):
        #        [setattr(self, name, __import__(name, globals(), locals(), [], -1)) for name in settings.INSTALLED_APPS]
        #setattr(django, 'Apps', Apps())
    except: pass
EOF

set tags+=$HOME/.vim/tags/python.tags

endfunction


function! CppSetup()
    call FindVimrcs()
    perl << EOF
        my $ver  = `g++ -dumpversion`;
        chomp $ver;
        my $path = "/usr/include/c++/$ver";
        VIM::SetOption("path+=$path/**") if -d $path;
EOF
    set tags+=$HOME/.vim/tags/c.tags,$HOME/.vim/tags/cpp.tags
    set path+=/usr/include/boost/**
endfunction

let hs_highlight_delimiters = 1
let hs_highlight_boolean = 1
let hs_highlight_types = 1
let hs_highlight_more_types = 1
let hs_highlight_debug = 1
au FileType haskell set makeprg=ghci\ %
au FileType python  set makeprg=python\ -i\ % | call PythonSetup()
au FileType qf set wrap
au BufNewFile,BufReadPost rules.am setf automake

highlight memset ctermbg=red guibg=red
match memset /memset.*\,\(\ \|\)0\(\ \|\));/

function! FindVimrcs()
    for item in reverse(findfile(".vimrc.local", ".;", -1))
        exec "source " . item
    endfor
endfunction

au FileType cpp call CppSetup()

let OmniCpp_ShowPrototypeInAbbr = 1
let OmniCpp_DefaultNamespaces = ["std"]
let OmniCpp_SelectFirstItem = 1
let OmniCpp_LocalSearchDecl = 1
let OmniCpp_DisplayMode = 0

nnoremap <Silent> <Leader>ll
      \ :if exists('w:long_line_match') <Bar>
      \   call matchdelete(w:long_line_match) <Bar>
      \   unlet w:long_line_match <Bar>
      \ elseif &textwidth > 0 <Bar>
      \   let w:long_line_match = matchadd('ErrorMsg','\%'.&tw+1.'v.*',-1) <Bar>
      \ else <Bar>
      \   let w:long_line_match = matchadd('ErrorMsg','\%81v.*',-1) <Bar>
      \ endif<CR>


hi String                                       ctermbg=Black                  guibg=#000000
hi Type                    ctermfg=DarkGreen                  guifg=#00aa00
hi TabLineFill  cterm=none                      ctermbg=DarkGrey
hi TabLine      cterm=none ctermfg=White        ctermbg=DarkGrey
hi TabLineSel   cterm=bold ctermfg=Green        ctermbg=DarkGrey

