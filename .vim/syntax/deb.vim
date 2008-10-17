" Vim syntax file for browsing debian package.
" copyright (C) 2007, arno renevier <arenevier@fdn.fr>
" Distributed under the GNU General Public License (version 2 or above)
" Last Change: 2007 December 07
"
" Latest version of that file can be found at
" http://www.fdn.fr/~arenevier/vim/syntax/deb.vim
" It should also be available at
" http://www.vim.org/scripts/script.php?script_id=1970

if exists("b:current_syntax")
 finish
endif

syn match debComment '^".*'
syn match debInfoFilename '^\* \.\/.*'
syn match debDataFilename '^\.\/.*[^/]$'
syn match debDirname '^\..*\/$'
syn match debSymlink '^\.\/.* -> .*$' contains=debSymlinkTarget,debSymlinkArrow,debSymlinkName
syn match debSymlinkName '^\S*' contained
syn match debSymlinkTarget '\S*$' contained
syn match debSymlinkArrow '->' contained

hi def link debComment	Comment
hi def link debInfoFilename Type
hi def link debDataFilename PreProc
hi def link debSymlinkName Identifier
hi def link debSymlinkTarget PreProc
