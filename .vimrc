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
set linebreak                       " Break lines in a polite fashion
set autoindent                      " Use previous line's indentation
"set cindent                         "    And augment it with c-style indentation
set nodigraph                       " No. I typo 1<BS>2 too much.
set ruler                           " Show line/column number
set wildmenu                        " Show a menu for cmdline completion
set wildmode=list:longest           "    And make it behave like the shell
set laststatus=2                    " Always show a status line
set shortmess=atIO                  " Get rid of most messages
set pastetoggle=<f11>               " hit f11 to paste
set nohlsearch                      " highlighting search hits is annoying
set history=1000                    " remember 1000 cmds
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

" Set up good status line
set laststatus=2
set statusline=
set statusline+=%-3.3n\                      " buffer number
set statusline+=%f\                          " file name
set statusline+=%h%m%r%w                     " flags
set statusline+=\[%{strlen(&ft)?&ft:'none'}, " filetype
set statusline+=%{&encoding},                " encoding
set statusline+=%{&fileformat}]              " file format
set statusline+=\ \[%{GetGitBranch()}]       " git branch
set statusline+=%=                           " right align
set statusline+=%-14.(%l,%c%V%)\ %<%P        " offset

" Set title string and push it to xterm/screen window title
" vim <truncate><fullpath>
set titlestring=%{fnameescape(hostname())}:\ vim\ %<%F%m%r%h
set titlelen=70
if &term == "screen"
  set t_ts=k
  set t_fs=\
endif
if &term == "screen" || &term == "xterm"
set title
endif

if &term ==? "xterm"
    set t_Sb=^[4%dm
    set t_Sf=^[3%dm
    set ttymouse=xterm2
endif

if &term ==? "rxvt-unicode" || &term ==? "screen"
    set t_Co=256
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
let python_slow_sync = 1
let g:xml_syntax_folding = 1

" Misc tweaks
let g:SuperTabLongestHighlight = 1
let g:compiler_gcc_ignore_unmatched_lines = 1
let g:alternateRelativeFiles = 1

" Haskell tweaks
let hs_highlight_delimiters = 1
let hs_highlight_boolean = 1
let hs_highlight_types = 1
let hs_highlight_more_types = 1
let hs_highlight_debug = 1

" Omnicpp tweaks
let OmniCpp_ShowPrototypeInAbbr = 1
let OmniCpp_DefaultNamespaces = ["std"]
let OmniCpp_SelectFirstItem = 1
let OmniCpp_LocalSearchDecl = 1
let OmniCpp_DisplayMode = 0

let git_diff_spawn_mode = 2
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

" Fix problem with vim's Man and ansi codes
let $GROFF_NO_SGR=1
so $VIMRUNTIME/ftplugin/man.vim

filetype plugin indent on

if 0 && ((&termencoding == "utf-8") || has("gui_running") && ! has("gui_win32"))
    set list listchars=tab:→·,trail:·,extends:⋯
else
    set list listchars=tab:>-,trail:.,extends:>,precedes:<
endif

command! MakeHtml runtime! syntax/2html.vim

if "" == &shell
    if executable("/bin/zsh")
        set shell=/bin/zsh
    elseif executable("/bin/bash")
        set shell=/bin/bash
    elseif executable("/bin/sh")
        set shell=/bin/sh
    endif
endif

if "" != $MY_TERM
    let g:myterm=$MY_TERM
else
    if executable("urxvt")
        let g:myterm="urxvt"
    else
        let g:myterm="xterm"
    endif
endif


augroup NewFiles
  au!
  au BufNewFile *.h call ShieldHeader()
  au BufNewFile *.cgi setf perl
  au BufNewFile,BufReadPost *.hdf setf hdf
  au BufNewFile,BufReadPost *.cs  setf cs
  au BufNewFile,BufReadPost *.kml setf xml
  au BufNewFile,BufReadPost *.mkd setf mkd
  au BufNewFile,BufReadPost rules.am setf automake
  au BufNewFile,BufReadPost *.oldtest setf cpp
  au BufNewFile,BufReadPost *.proto setf proto
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g`\"" | endif

  au BufReadCmd *.kmz call zip#Browse(expand("<amatch>"))
  au BufReadCmd *.xpi call zip#Browse(expand("<amatch>"))
  au BufRead,BufNewFile *.vala            setfiletype vala
  au BufRead,BufNewFile *.vapi            setfiletype vala
augroup END

function! FloatingTerm(cmd)
    let cmd = "setlocal makeprg=" . g:myterm . "\\ -T\\ please-float-me\\ -fn\\ fixed\\ -e\\ " . &shell . "\\ -c\\ " . escape(shellescape(a:cmd), ' ')
    exec cmd
endfunction

function! SetPython(py)
    call FloatingTerm(a:py . " -i %")
endfunction

augroup Filetype
  au!
  au FileType c,cpp compiler gcc
  au FileType c call CSetup() | set cindent
  au FileType cpp call CppSetup()
  au FileType crontab setlocal backupcopy=yes
  au FileType cvs s,^,\r, | startinsert
  au FileType ebuild setlocal ts=4 sw=4 noexpandtab list!
  au FileType haskell call FloatingTerm("ghci %")
  au FileType html,xml,xhtml,xslt setlocal nu shiftwidth=2 tabstop=2
  au FileType java compiler javac
  au FileType mail setlocal tw=72 spell
  au FileType make setlocal noexpandtab
  au FileType none call UpdateSpellFile()
  au FileType notes call NoteDate() | call NoteTime() | au! FileType notes | startinsert
  au FileType python  call FloatingTerm("ipython -i %") | call PythonSetup()
  au FileType qf set wrap
  au FileType scheme setlocal lispwords-=if | set lispwords+=define-macro | set sw=2 ts=2 | set makeprg=gosh-rl\ -l%
  au FileType plaintex,tex call UpdateSpellFile() | call SetupTexSpell() | setlocal spell tw=80 makeprg=latexmk\ -pdf\ %< | map <F5> :call RunOnce("open %<.pdf", "%<.pdf")<CR>
  au FileType vo_base set makeprg=otl2html.py\ %\ >\ /tmp/vim-otl.html\ &&\ firefox\ /tmp/vim-otl.html
  au FileType dot set makeprg=dot\ -Tpdf\ -o%.pdf\ %
  au FileType mkd set ai formatoptions=tcroqn2 comments=n:>
  au FileType vala set efm=%f:%l.%c-%[%^:]%#:\ %t%[%^:]%#:\ %m
  au FileType man set nolist ts=8
augroup END

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

noremap   <F3>  n
nmap      <F4>  gwapvap:s/\.  /\. /g<CR>
nnoremap  <F5>  :make! run<CR>
nnoremap  <F9>  :make!<CR>
nnoremap  <F12> :set list!<CR>
nnoremap  <silent> <leader>ss m`:%s/\s\s*$//e<CR>``
map Q gq

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

" rxvt
map Oc <C-Right>
map Od <C-Left>
map! Oc <C-Right>
map! Od <C-Left>

" screen
map [1;5C <C-Right>
map [1;5D <C-Left>
map! [1;5C <C-Right>
map! [1;5D <C-Left>

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

"map <Leader>h  :A<CR>
"map <Leader>sh :AV<CR>
function! PythonSetup()

if has('python')
    set path=
    exec 'pyfile ' . GetOutsideScript('SetPaths.py')
endif

setlocal omnifunc=pysmell#Complete
set tags+=$HOME/.vim/tags/python.tags

endfunction

function! HasOrThrow(feature)
    if ! has(a:feature)
        throw 'Mike: I need ' . a:feature . ' support'
    endif
endfunction

function! GetOutsideScript(name, ...)
    let l:script = globpath(&rtp, 'scripts/' . a:name)
    if l:script == ''
        throw 'Mike: Missing script ' . a:name
    endif
    return l:script
endfunction

"command! -register -range SwapArguments call SwapArguments()
function! SwapArguments()
    try
        call HasOrThrow('python')
        exec 'pyfile ' . GetOutsideScript('SwapArguments.py')
    catch /^Mike:\(*.*\)/
        echohl ErrorMsg | echo v:exception | echohl None
    endtry
endfunction


function! CSetup()
    call FindVimrcs()
    set tags+=$HOME/.vim/tags/c.tags
endfunction

function! CppSetup()
    try
        call FindVimrcs()
        call HasOrThrow('python')
        "exec 'pyfile ' . GetOutsideScript('CppSetup.py')
    catch /^Mike:\(*.*\)/
        echohl ErrorMsg | echo v:exception | echohl None
    endtry

    set tags+=$HOME/.vim/tags/c.tags,$HOME/.vim/tags/cpp.tags
    set path+=/usr/include/boost/**
endfunction


highlight memset ctermbg=red guibg=red
match memset /memset.*\,\(\ \|\)0\(\ \|\));/

function! FindVimrcs()
    for item in reverse(findfile(".vimrc.local", ".;", -1))
        exec "source " . item
    endfor
endfunction

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
hi Type                       ctermfg=DarkGreen                  guifg=#00aa00
hi TabLineFill  cterm=none                      ctermbg=DarkGrey
hi TabLine      cterm=none    ctermfg=White        ctermbg=DarkGrey
hi TabLineSel   cterm=bold    ctermfg=Green        ctermbg=DarkGrey
hi MatchParen   term=reverse  ctermbg=DarkBlue guibg=DarkBlue
hi Folded       term=standout ctermfg=244           ctermbg=235
hi SpecialChar  ctermfg=135 ctermbg=none


set hidden
nnoremap ' `
nnoremap ` '
set ignorecase
set smartcase
set backupdir=~/.vim/tmp
set directory=~/.vim/tmp
set sidescroll=3
set sidescrolloff=3
set timeoutlen=300

" Indent XML readably
function! DoPrettyXML()
  1,$!xmllint --format --recover --valid -
endfunction
function! DoPrettyHTML()
  1,$!xmllint --format --recover --html --xmlout --valid -
endfunction
command! PrettyXML call DoPrettyXML()
command! PrettyHTML call DoPrettyHTML()
set matchpairs+=<:>

nnoremap <m-w> :exe 'vertical belowright wincmd '.nr2char(getchar())<CR>
set printexpr=system('gtklp'\ .\ '\ '\ .\ v:fname_in)\ .\ delete(v:fname_in)\ +\ v:shell_error

if has("cscope")
    set cscopetag
    set nocscopeverbose
    set csto=0
endif

nnoremap <silent> <C-l> :nohl<CR><C-l>
set hlsearch
" After shifting a visual block, select it again
vnoremap < <gv
vnoremap > >gv

"noremap qp Go^]"qp
"noremap qd G0"qdd
