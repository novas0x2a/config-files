scriptencoding utf-8

set nocompatible                    " Yay ViM!

call plug#begin('~/.vim/plugged')
Plug 'tpope/vim-sensible'
Plug 'novas0x2a/vim-git'
Plug 'ciaranm/inkpot'
Plug 'tpope/vim-fugitive'
Plug 'tweekmonster/startuptime.vim'
Plug 'neomake/neomake'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-dispatch'
Plug 'ap/vim-templates'
Plug 'vim-scripts/Align'
Plug 'vim-scripts/bufexplorer.zip'
Plug 'vim-scripts/deb.vim'
Plug 'vim-scripts/matchit.zip'
Plug 'vim-scripts/xmledit'
Plug 'vim-airline/vim-airline'
Plug 'gerw/vim-HiLinkTrace'
Plug 'milkypostman/vim-togglelist'
Plug 'koron/nyancat-vim'
Plug 'mhinz/vim-startify'
Plug 'kien/rainbow_parentheses.vim'
Plug 'mhaig/vim-blockdiag-series'
Plug 'hashivim/vim-vagrant'
Plug 'Shougo/vimproc'
Plug 'hashivim/vim-terraform'
Plug 'mustache/vim-mustache-handlebars'
"Plug 'gabrielelana/vim-markdown'
Plug 'vim-scripts/bats.vim'
Plug 'editorconfig/editorconfig-vim'
Plug 'google/vim-jsonnet'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'vim-test/vim-test'
Plug 'mattn/gist-vim'               ,{'on': 'Gist'}
Plug 'mattn/webapi-vim'             ,{'on': 'Gist'}
"Plug 'wincent/command-t'            ,{'do': 'cd ruby/command-t/ext/command-t && ruby extconf.rb && make'}
Plug 'olethanh/Vim-nosecompiler'    ,{'for': 'python'}
Plug 'vim-scripts/pylint.vim'       ,{'for': 'python'}
Plug 'alfredodeza/coveragepy.vim'   ,{'for': 'python'}
Plug 'jmcantrell/vim-virtualenv'    ,{'for': 'python'}

Plug 'ivanov/vim-ipython'           ,{'for': 'python'}
Plug 'alfredodeza/pytest.vim'       ,{'for': 'python'}
Plug 'hdima/python-syntax'          ,{'for': 'python'}
Plug 'fatih/vim-go'                 ,{'for': 'go'}
Plug 'tsandall/vim-rego'            ,{'for': 'rego'}
Plug 'jparise/vim-graphql'
Plug 'sheerun/vim-polyglot'

call plug#end()

" load sensible now so i can override it where necessary (otherwise it runs at
" the end of vimrc)
call plug#load('vim-sensible')

let g:inkpot_black_background = 1

augroup MyColorMods
    au!
    autocmd ColorScheme inkpot
        \   hi String                                       ctermbg=Black                  guibg=#000000
        \ | hi Type                       ctermfg=DarkGreen                  guifg=#00aa00
        \ | hi TabLineFill  cterm=none                      ctermbg=DarkGrey
        \ | hi TabLine      cterm=none    ctermfg=White        ctermbg=DarkGrey
        \ | hi TabLineSel   cterm=bold    ctermfg=Green        ctermbg=DarkGrey
        \ | hi MatchParen   term=reverse  ctermbg=DarkBlue guibg=DarkBlue
        \ | hi Folded       term=standout ctermfg=244           ctermbg=235
        \ | hi SpecialChar  ctermfg=135 ctermbg=none
        \ | hi link NeomakeErrorSign ErrorMsg
        \ | hi link NeomakeWarningSign WarningMsg
        \ | hi link NeomakeError   NeomakeErrorSign
        \ | hi link NeomakeWarning NeomakeWarningSign
augroup END

set background=dark                 " Well, it /is/ dark...
colorscheme inkpot                  " My colorscheme's better

set expandtab                       " Use spaces, not tabs.
set tabstop=4                       " Tabs are 4 spaces
set shiftwidth=4                    " Indent is 4 spaces
set nowrap                          " The wrapping behavior is annoying
set showmatch                       " Point out matched parens
set matchtime=2                     " Show match for 0.2 sec
set scrolloff=10                    " Context lines around cursor
set linebreak                       " Break lines in a polite fashion
set nodigraph                       " No. I typo 1<BS>2 too much.
set wildmode=list:longest           "    And make it behave like the shell
set wildignore+=htmlcov/*
set laststatus=2                    " Always show a status line
set shortmess=atIO                  " Get rid of most messages
set pastetoggle=<f11>               " hit f11 to paste
set nohlsearch                      " highlighting search hits is annoying
set showcmd                         " show typed command in progress
set suffixes+=.info,.aux,.log,.dvi,.bbl,.out " ignore tex intermediates for menu
set autowrite                       " Autosave on some buffer-switching ops
set formatoptions+=n                " Recognize numbered lists
set formatlistpat=^\\s*\\(\\d\\\|[-*]\\)\\+[\\]:.)}\\t\ ]\\s* "and bullets, too
set grepprg=grep\ -nH\ $*           " Always show filename for grep
set numberwidth=3                   " 3-digit line numbers
set updatetime=2000                 " Wait before triggering CursorHold event

" This prevents vim from waiting for input (after the esc) when exiting insert
" mode. (If insert mode starts fucking up, look here first)
set ttimeoutlen=0

set switchbuf=useopen,usetab        " Try to switch to an open tab
if version >= 702
    set switchbuf+=newtab
endif

set showtabline=1                   " Show tab line if more than one tab open
set nolazyredraw                    " Delay redrawing the screen
set novisualbell                    " Don't you dare flash the screen
set t_vb=                           "   No, really, I'll hurt you if you do.
set noerrorbells                    " And don't bell me with errors, either
set nomore                          " Display all of the message at once
set secure                          " Turn on vimrc security
set noexrc                          "   ... and don't allow local-directory vimrcs
set completeopt=longest,menuone,preview " Make code-completion spiffy
set path+=/usr/local/include        " local should be in the default path

let g:airline#extensions#tabline#enabled = 0
let g:airline#extensions#whitespace#enabled = 0
let g:airline#extensions#tabline#show_splits = 0
let g:airline#extensions#tabline#show_tab_nr = 0
let g:airline#extensions#tabline#show_close_button = 0
let g:airline#extensions#tabline#show_buffers = 0

" Set up good status line
"set statusline=
"set statusline+=%-3.3n\                      " buffer number
"set statusline+=%f\                          " file name
"set statusline+=%h%m%r%w                     " flags
"set statusline+=\[%{strlen(&ft)?&ft:'none'}, " filetype
"set statusline+=%{&encoding},                " encoding
"set statusline+=%{&fileformat}]              " file format
"set statusline+=\ %{fugitive#statusline()}   " git branch
"set statusline+=\ %{virtualenv#statusline()} " virtualenv
"set statusline+=%=                           " right align
"set statusline+=%-14.(%l,%c%V%)\ %<%P        " offset


" Set title string and push it to xterm/screen window title
" vim <truncate><fullpath>
set titlestring=%{fnameescape(hostname())}:\ vim\ %<%F%m%r%h
set titlelen=70

if &term =~? "screen"
  " Make sure set title works for screen
  set t_ts=k
  set t_fs=\
  set title
endif

if &term =~? "xterm*"
  set title
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
let python_version_2 = 1
let g:xml_syntax_folding = 1

" Misc tweaks
let g:SuperTabLongestHighlight = 1
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
let OmniCpp_MayCompleteDot = 0
let OmniCpp_MayCompleteArrow = 0
let OmniCpp_MayCompleteScope = 0

" Neomake
let g:neomake_open_list=2
let g:neomake_list_height=10
let g:neomake_error_sign   = {'text': 'E➤', 'texthl': 'NeomakeErrorSign'}
let g:neomake_warning_sign = {'text': 'W➤', 'texthl': 'NeomakeWarningSign'}
let g:neomake_message_sign = {'text': 'M➤', 'texthl': 'NeomakeMessageSign'}
let g:neomake_info_sign    = {'text': 'I➤', 'texthl': 'NeomakeInfoSign'}
autocmd! BufWritePost * Neomake

" This hides the row/column info in the qf list
"autocmd! BufReadPost quickfix
"    \  if exists('b:myConcealCol')
"    \|     call matchdelete(b:myConcealCol)
"    \| endif
"    \| let b:myConcealCol  = matchadd("Conceal", "|[^|]*|", 999, -1, {'conceal': ''})
"    \| setlocal conceallevel=2 concealcursor=nv
"
"    "| if exists('b:myConcealPath')
"    "|     echom 'deleting match'
"    "|     call matchdelete(b:myConcealPath)
"    "| endif
"    "| let b:myConcealPath = matchadd("Conceal", "^[^|]*/", 999, -1, {'conceal': ''})

let g:neomake_serialize=1
let g:neomake_serialize_abort_on_error=1

let g:neomake_python_enabled_makers = ['python', 'pycodestyle', 'pylint']

"let s:default_pylint_maker = neomake#GetMaker('pylint', 'python')
"let g:neomake_pylint_append_file = 0
"let g:neomake_pylint_args = {}
"function g:neomake_pylint_args.fn()
"    let module_init = join([expand('%:p:h'), '__init__.py'], '/')
"    if filereadable(module_init)
"        return s:default_pylint_maker['args'] + GetPylintRCArgs() + [expand('%:p:h')]
"    else
"        return s:default_pylint_maker['args'] + GetPylintRCArgs() + [expand('%:p')]
"    fi
"endfunction

"let s:default_pep8_maker = neomake#GetMaker('pep8', 'python')
"let g:neomake_pep8_append_file = 0
"let g:neomake_pep8_args = {}
"function g:neomake_pep8_args.fn()
"    return s:default_pep8_maker['args'] + GetPep8RCArgs() + [expand('%:p:h')]
"endfunction
"
"let s:default_pycodestyle_maker = neomake#GetMaker('pycodestyle', 'python')
"let g:neomake_pycodestyle_append_file = 0
"let g:neomake_pycodestyle_args = {}
"function g:neomake_pycodestyle_args.fn()
"    return s:default_pycodestyle_maker['args'] + GetPep8RCArgs() + [expand('%:p:h')]
"endfunction

"let g:neomake_python_enabled_makers = ['pylint']
"let s:pylint_maker = neomake#GetMaker('pylint', 'python')
"function s:pylint_maker.fn() dict
"    let self.args = extend(self.args, [GetPylintRCArgs(), expand('%:p:h')])
"    let self.append_file = 0
"    return self
"endfunction

let g:neomake_go_enabled_makers = ['go', 'golangci_lint']
"let g:neomake_go_enabled_makers = ['go', 'gometalinter']
"let g:neomake_go_gometalinter_args = ['--fast', '--disable', 'gotype', '--disable', 'gocyclo', '--disable', 'goconst', '--disable', 'gas', '--disable', 'gosec', '--enable-gc', '--vendor', './...']
let g:neomake_go_golangci_lint_args = neomake#makers#ft#go#golangci_lint().args + ['--fast', '.']

" vim-go tweaks
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_fields = 1
let g:go_highlight_structs = 1
let g:go_highlight_interfaces = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1
let g:go_metalinter_autosave = 0
" guru is just too slow
"let g:go_def_mode = 'godef'
let g:go_def_mode = 'gopls'

let g:yankring_history_dir = "~/.vim/tmp"

" Make erroformat ignore unmatched gcc output lines
let g:compiler_gcc_ignore_unmatched_lines = 1

" ctrl-p tweaks
let g:ctrlp_match_window = 'top,order:btt,min:3,max:20,results:100'
let g:ctrlp_use_caching = 1
let g:ctrlp_max_files = 80000
let g:ctrlp_brief_prompt = 1
let g:ctrlp_open_multiple_files = 't'
let g:ctrlp_open_new_file = 't'
let g:ctrlp_follow_symlinks = 1
let g:ctrlp_prompt_mappings = {
    \ 'AcceptSelection("e")': ['<2-LeftMouse>'],
    \ 'AcceptSelection("t")': ['<cr>', '<c-t>'],
\}
nmap <unique> <silent> <Leader>f :exe "CtrlP " . GetMyProjectRoot()<CR>

" vim-virtualenv
let g:virtualenv_stl_format = '[venv:%n]'

" gist
let gist_detect_filetype = 1
let gist_open_browser_after_post = 1
let gist_post_private = 1
let gist_show_privates = 1
let gist_get_multiplefile = 1
let g:gist_update_on_write = 2


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

if ((&termencoding == "utf-8") || has("gui_running") && ! has("gui_win32"))
    set list listchars=tab:→·,trail:·,extends:⋯
else
    set list listchars=tab:>-,trail:.,extends:>,precedes:<
endif

command! Htmlize runtime! syntax/2html.vim

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


command -nargs=1 -complete=filetype SetFileType call SetFileType(<f-args>)
function! SetFileType(ft)
    exec 'setlocal filetype=' . a:ft
    try | exec 'compiler ' . a:ft  | catch /./ | endtry
endfunction


function! IdentifyBlockDiag()
  let line1 = getline(1)

  if line1 =~ '\<diagram\|blockdiag\>\s*{'
      SetFileType blockdiag
  elseif line1 =~ '\<seqdiag\>\s*{'
      SetFileType seqdiag
  elseif line1 =~ '\<actdiag\>\s*{'
      SetFileType actdiag
  elseif line1 =~ '\<nwdiag\>\s*{'
      SetFileType nwdiag
  elseif line1 =~ '\<rackdiag\>\s*{'
      SetFileType rackdiag
  elseif line1 =~ '\<packetdiag\>\s*{'
      SetFileType packetdiag
  endif

endfunction


augroup NewFiles
  au!
  au BufNewFile *.h call ShieldHeader()
  au BufNewFile,BufReadPost *.cgi         SetFileType perl
  au BufNewFile,BufReadPost *.hdf         SetFileType hdf
  au BufNewFile,BufReadPost *.cs          SetFileType cs
  au BufNewFile,BufReadPost *.kml         SetFileType xml
  au BufNewFile,BufReadPost rules.am      SetFileType automake
  au BufNewFile,BufReadPost *.oldtest     SetFileType cpp
  au BufNewFile,BufReadPost *.proto       SetFileType proto
  au BufNewFile,BufReadPost *.vala,*.vapi SetFileType vala
  au BufNewFile,BufReadPost *.frag,*.vert,*.fp,*.vp,*.glsl SetGLSLFileType
  au BufNewFile,BufReadPost *.cc          SetFileType cpp
  au BufNewFile,BufReadPost *.j2          SetFileType jinja
  au BufNewFile,BufReadPost *.cv1         SetFileType moxie_expectation
  au BufNewFile,BufReadPost *.diag        call IdentifyBlockDiag()
  au BufNewFile,BufReadPost *.gotmpl      SetFileType gotexttmpl
  au BufNewFile,BufReadPost *.gohtml      SetFileType gohtmltmpl

  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g`\"" | endif

  au BufReadCmd *.kmz call zip#Browse(expand("<amatch>"))
  au BufReadCmd *.xpi call zip#Browse(expand("<amatch>"))
augroup END

function! SetMakePrg(args)
    let cmd = 'setlocal makeprg=' . fnameescape(join(a:args))
    exec cmd
endfunction

function! FloatingTerm(cmd)
    call SetMakePrg([g:myterm, '-T', 'please-float-me', '-fn', 'fixed', '-e', &shell, '-c', shellescape(a:cmd)])
endfunction

function! SetPython(py)
    call FloatingTerm(a:py . " -i %")
endfunction

augroup Filetype
  au!
  au FileType c,cpp compiler gcc
  au FileType tex compiler tex
  au FileType c call CSetup() | setlocal cindent
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
  au FileType qf setlocal wrap
  au FileType scheme setlocal lispwords-=if | setlocal lispwords+=define-macro | setlocal sw=2 ts=2 | call FloatingTerm('gosh-rl -l%')
  au FileType plaintex,tex call UpdateSpellFile() | call SetupTexSpell() | setlocal spell tw=80 makeprg=latexmk\ -pdf\ %< | map <F5> :call RunOnce("open %<.pdf", "%<.pdf")<CR>
  au FileType vo_base call SetMakePrg(['otl2html.py % > %.html && xdg-open %.html'])
  au FileType dot call SetMakePrg(['dot', '-Tpdf', '-o%.pdf', '%'])
  "au FileType mkd setlocal ai formatoptions=tcroqn2 comments=n:>
  au FileType mkd call SetMakeProg(['make'])
  au FileType vala setlocal efm=%f:%l.%c-%[%^:]%#:\ %t%[%^:]%#:\ %m
  au FileType man setlocal nolist ts=8
  au FileType gitcommit setlocal spell | exec 'setlocal previewheight='. winwidth(0)/2 | DiffGitCached
  au FileType markdown call SetMakePrg(['markdown -f /tmp/%.html % && xdg-open /tmp/%.html'])
  au FileType terraform setlocal ts=2 sw=2

  au FileType c,cpp,python,scheme,java RainbowParenthesesToggle
  au FileType moxie_expectation setlocal noexpandtab shiftwidth=16 tabstop=16
  au FileType yaml setlocal sw=2 ts=2
  au FileType go call GoSetup()
  au FileType rego setlocal noexpandtab shiftwidth=4 tabstop=4
augroup END

" vim -b : edit binary using xxd-format!
augroup Binary
  au!
  au BufReadPre  *.bin let &bin=1
  au BufReadPost *.bin if &bin | %!xxd -g1 -u
  au BufReadPost *.bin setlocal ft=xxd | endif
  au BufWritePre *.bin if &bin | %!xxd -r
  au BufWritePre *.bin endif
  au BufWritePost *.bin if &bin | %!xxd
  au BufWritePost *.bin setlocal nomod | endif
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
    exec "setlocal spellfile=" . localspell . "," . texspell
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
map <leader>tf :tabfind<space>
map <leader>te :tabedit<space>

noremap <C-Right>  :tabnext<cr>
noremap <C-Left>   :tabprev<cr>
inoremap <C-Right> <esc>:tabnext<cr>
inoremap <C-Left>  <esc>:tabprev<cr>

" rxvt
if &term == "rxvt"
    map Oc <C-Right>
    map Od <C-Left>
    map! Oc <C-Right>
    map! Od <C-Left>
endif

if &term =~? "screen*"
    " <DecMouse> seems to be ^[[ if vim is compiled with it. That breaks this
    " bind. I don't have a DEC.
    set <DecMouse>=
    map [1;5C <C-Right>
    map [1;5D <C-Left>
    map! [1;5C <C-Right>
    map! [1;5D <C-Left>
endif

nnoremap <silent> <leader>o :TlistToggle<CR>

"nmap <leader>e :botright cwindow 10<cr>
"nmap <leader>r :botright lwindow 10<cr>
noremap <script> <silent> <leader>e :call ToggleLocationList()<CR>
noremap <script> <silent> <leader>r :call ToggleQuickfixList()<CR>

let g:toggle_list_no_mappings=0


nmap <leader>w :w<cr>
nmap <leader>q :q<cr>
nmap <leader>Q :confirm qall<cr>

" Pressing PageUp then PageDown can leave your cursor in a different place. This fixes that.
map <PageUp> <C-U>
map <PageDown> <C-D>

" Disabled because mouse is annoying. The main reason to enable this is so
" block selection in split windows word sanely, but the tradeoff is it's no
" longer possible to select text in status lines (it selects the window
" instead) and the only way to configure what double-click considers is a word
" is iskeyword, which means that daw and friends will now consider . to be a
" word, which is sub-optimal...
" set mouse=a
" set selectmode=mouse

"map <Leader>h  :A<CR>
"map <Leader>sh :AV<CR>
function! PythonPath()
    let l:py = 'import os.path; import sys; print(",".join(p.replace(" ", r"\ ") for p in sys.path if os.path.exists(p)))'
    return system('python', l:py)
endfunction

function! PythonSetup()
    exec 'setlocal path=' . PythonPath()
    let srcdir = GetMyProjectRoot() . '/src'
    if isdirectory(srcdir)
        exec 'setlocal path+=' . fnameescape(srcdir)
    endif

    setlocal omnifunc=pysmell#Complete
    setlocal tags+=$HOME/.vim/tags/python.tags
    exec 'setlocal tags^=' . fnameescape(GetMyProjectRoot() . '/tags')
    if version >= 703
        setlocal colorcolumn=80,100,120
    endif
    compiler nose
    setlocal makeprg=pylint\ %

    function! CommandTBullshit()
        echo system(GetOutsideScript('commandtbullshit.py'))
    endfunction

    nmap <buffer> <silent> <Leader>l :exe "CtrlP" . system(GetOutsideScript('commandtbullshit.py'))<CR>

    set wildignore+=*.pyc
    set wildignore+=*.pyo
    set wildignore+=*egg-info*
    set wildignore+=*EGG-INFO*

    nmap <silent> <leader>tr :TestNearest<CR>
    nmap <silent> <leader>tf :TestFile<CR>
    nmap <silent> <leader>ta :TestSuite<CR>
endfunction

function! GoSetup()
    nmap <silent> <leader>tr :GoTestFunc!<CR>
    nmap <silent> <leader>tf :GoTest!<CR>
    nmap <silent> <leader>ta :GoTest! ./...<CR>

    if ((&termencoding == "utf-8") || has("gui_running") && ! has("gui_win32"))
        setlocal list listchars=tab:\ \ ,trail:·,extends:⋯
    else
        setlocal list listchars=tab:\ \ ,trail:.,extends:>,precedes:<
    endif

    "setlocal wildignore+=*/vendor/*
    if version >= 703
        setlocal colorcolumn=80,100,120
    endif

    "nmap <buffer> <silent> <Leader>f :exe "setlocal wildignore+=*/vendor/* | CommandT " . GetMyProjectRoot() . "| setlocal wildignore-=*/vendor/*"<CR>
    "nmap <buffer> <silent> <Leader>l :exe "CommandT " . GetMyProjectRoot()<CR>
    "nmap <buffer> <silent> <Leader>l :exe "CommandT " . system(GetOutsideScript('commandtbullshit.py'))<CR>

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
    setlocal sw=2 ts=2 tw=100
    setlocal tags+=$HOME/.vim/tags/c.tags
    setlocal wildignore+=*.la,*.lo,*.o,*.a
    exec 'setlocal path^=' . fnameescape(GetMyProjectRoot() . '/**')
    exec 'setlocal tags^=' . fnameescape(GetMyProjectRoot() . '/tags')
    setlocal comments^=:///
endfunction

function! CppSetup()
    call CSetup()
    setlocal tags+=$HOME/.vim/tags/cpp.tags
    setlocal path+=/usr/include/boost/**
endfunction

highlight memset ctermbg=red guibg=red
match memset /memset.*\,\(\ \|\)0\(\ \|\));/

function! GetPylintRC()
    if ! exists("b:pylintrc")
        let tmp = findfile('.pylintrc', '.;')
        if tmp != ''
            let b:pylintrc = fnamemodify(tmp, ":p")
        else
            let b:pylintrc = ''
        endif
    endif
    return b:pylintrc
endfunction

function! GetPep8RC()
    if ! exists("b:pep8rc")
        let tmp = findfile('.pycodestyle', '.;')
        if tmp != ''
            let b:pep8rc = fnamemodify(tmp, ":p")
        else
            let tmp = findfile('.pep8', '.;')
            if tmp != ''
                let b:pep8rc = fnamemodify(tmp, ":p")
            else
                let b:pep8rc = ''
            endif
        endif
    endif
    return b:pep8rc
endfunction

function! GetPylintRCArgs()
    let rc = GetPylintRC()
    if rc != ''
        return ['--rcfile=' . rc]
    endif
    return []
endfunction

function! GetPep8RCArgs()
    let rc = GetPep8RC()
    if rc != ''
        return ['--config=' . rc]
    endif
    return []
endfunction

function! FindVimrcs()
    " Find all local vimrcs, and run them in order from least-specific to
    " most-specific (in order to allow more specific ones to override)
    for item in reverse(findfile(".vimrc.local", ".;", -1))
        let full_item = fnamemodify(item, ":p")
        try
            let b:vimrc_local = add(b:vimrc_local, full_item)
        catch /^Vim\%((\a\+)\)\=:E121/ " variable undefined
            let b:vimrc_local = [full_item]
        endtry

        if filereadable(item)
            exec "source " . item
        endif
    endfor
endfunction

let g:project_root_hints = ["setup.py", "configure", ".git"]

function! GetMyProjectRoot()
    if ! exists("b:project_root")
        let search = getcwd()
        let b:project_root = search

        while search !=# '/'
            " echo "root is " . b:project_root
            if exists("b:project_root")
                break
            endif

            if search ==# $HOME
                break
            endif

            " echo "checking " . search
            for fn in g:project_root_hints
                " echo "finding " . fn
                let path = search . "/" . fn
                if !empty(glob(path, 1))
                    " echo "found " . search
                    let b:project_root = search
                    break
                endif
            endfor

            let search = fnamemodify(search, ":h")
        endwhile
    endif
    return b:project_root
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


set hidden
nnoremap ' `
nnoremap ` '
set ignorecase
set smartcase
set backupdir=~/.vim/tmp
set directory=~/.vim/tmp
set sidescroll=3
set sidescrolloff=3

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

nnoremap <silent> <C-l> :nohlsearch<CR><C-l>
set hlsearch
" After shifting a visual block, select it again
vnoremap < <gv
vnoremap > >gv

command SetGLSLFileType call SetGLSLFileType()
function SetGLSLFileType()
    let v='glsl'
    for item in getline(1,10)
        if item =~ "#version 400"
            let v='glsl400'
            break
        elseif item =~ "#version 330"
            let v='glsl330'
            break
        endif
    endfor
    exec 'set filetype=' . v
endfunction

nnoremap <silent> <leader>DD :exe ":profile start ~/.vim/tmp/profile.log"<cr>:exe ":profile func *"<cr>:exe ":profile file *"<cr>
nnoremap <silent> <leader>DQ :exe ":profile pause"<cr>:noautocmd qall!<cr>
