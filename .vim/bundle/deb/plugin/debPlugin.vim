" debPlugin.vim -- a Vim plugin for browsing debian packages
" copyright (C) 2007, arno renevier <arenevier@fdn.fr>
" Distributed under the GNU General Public License (version 2 or above)
" Last Change: 2007 December 07
"
" This file only sets the autocommands. Functions are in autoload/deb.vim.
"
" Latest version of that file can be found at
" http://www.fdn.fr/~arenevier/vim/plugin/debPlugin.vim
" It should also be available at
" http://www.vim.org/scripts/script.php?script_id=1970
"
if &cp || exists("g:loaded_debPlugin") || !has("unix") || v:version < 700
    finish
endif
let g:loaded_debPlugin = 1

autocmd BufReadCmd   *.deb		call deb#browse(expand("<amatch>"))
