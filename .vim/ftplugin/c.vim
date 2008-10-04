" Vim filetype plugin file
"
"   Language :  C / C++
"     Plugin :  c.vim (version 5.2)
" Maintainer :  Fritz Mehner <mehner@fh-swf.de>
"   Revision :  $Id: c.vim,v 1.27 2008/08/07 14:57:48 mehner Exp $
"
" This will enable keyword completion for C and C++
" using Vim's dictionary feature |i_CTRL-X_CTRL-K|.
" -----------------------------------------------------------------
"
" Only do this when not done yet for this buffer
" 
if exists("b:did_C_ftplugin")
  finish
endif
let b:did_C_ftplugin = 1
"
" ---------- C/C++ dictionary -----------------------------------
" 
if exists("g:C_Dictionary_File")
    silent! exec 'setlocal dictionary+='.g:C_Dictionary_File
endif    
"
" ---------- F-key mappings  ------------------------------------
"
"   Alt-F9   write buffer and compile
"       F9   compile and link
"  Ctrl-F9   run executable
" Shift-F9   command line arguments
"
" map  <buffer>  <silent>  <A-F9>       :call C_Compile()<CR>:redraw<CR>:call C_HlMessage()<CR>
"imap  <buffer>  <silent>  <A-F9>  <C-C>:call C_Compile()<CR>:redraw<CR>:call C_HlMessage()<CR>
""
" map  <buffer>  <silent>    <F9>       :call C_Link()<CR>:redraw<CR>:call C_HlMessage()<CR>
"imap  <buffer>  <silent>    <F9>  <C-C>:call C_Link()<CR>:redraw<CR>:call C_HlMessage()<CR>
"
" <C-C> seems to be essential here:
" map  <buffer>  <silent>  <C-F9>       :call C_Run()<CR>
"imap  <buffer>  <silent>  <C-F9>  <C-C>:call C_Run()<CR>
""
" map  <buffer>  <silent>  <S-F9>       :call C_Arguments()<CR>
"imap  <buffer>  <silent>  <S-F9>  <C-C>:call C_Arguments()<CR>
"
" alternate file plugin
"
" ---------- KEY MAPPINGS : MENU ENTRIES -------------------------------------
"
" ---------- comments menu  ------------------------------------------------
"
 noremap    <buffer>  <silent>  <Leader>ccl         :call C_LineEndComment()<CR>
inoremap    <buffer>  <silent>  <Leader>ccl    <Esc>:call C_LineEndComment()<CR>a
vnoremap    <buffer>  <silent>  <Leader>ccl    <Esc>:call C_MultiLineEndComments()<CR>
 noremap    <buffer>  <silent>  <Leader>ccj         :call C_AdjustLineEndComm("a")<CR>
vnoremap    <buffer>  <silent>  <Leader>ccj    <Esc>:call C_AdjustLineEndComm("v")<CR>
inoremap    <buffer>  <silent>  <Leader>ccj    <Esc>:call C_AdjustLineEndComm("a")<CR>a
 noremap    <buffer>  <silent>  <Leader>ccs         :call C_GetLineEndCommCol()<CR>

 noremap    <buffer>  <silent>  <Leader>cc*         :call C_CodeComment("a","yes")<CR>:nohlsearch<CR>j
vnoremap    <buffer>  <silent>  <Leader>cc*    <Esc>:call C_CodeComment("v","yes")<CR>:nohlsearch<CR>j
 noremap    <buffer>  <silent>  <Leader>cc/         :call C_CodeComment("a","no")<CR>:nohlsearch<CR>j
vnoremap    <buffer>  <silent>  <Leader>cc/    <Esc>:call C_CodeComment("v","no")<CR>:nohlsearch<CR>j

 noremap    <buffer>  <silent>  <Leader>ccc         :call C_CodeComment("a","no")<CR>:nohlsearch<CR>j
vnoremap    <buffer>  <silent>  <Leader>ccc    <Esc>:call C_CodeComment("v","no")<CR>:nohlsearch<CR>j
 noremap    <buffer>  <silent>  <Leader>cco         :call C_CommentCode("a")<CR>:nohlsearch<CR>
vnoremap    <buffer>  <silent>  <Leader>cco    <Esc>:call C_CommentCode("v")<CR>:nohlsearch<CR>

 noremap    <buffer>  <silent>  <Leader>ccfr        :call C_InsertTemplate("comment.frame")<CR>
 noremap    <buffer>  <silent>  <Leader>ccfu        :call C_InsertTemplate("comment.function")<CR>
 noremap    <buffer>  <silent>  <Leader>ccme        :call C_InsertTemplate("comment.method")<CR>
 noremap    <buffer>  <silent>  <Leader>cccl        :call C_InsertTemplate("comment.class")<CR>

inoremap    <buffer>  <silent>  <Leader>ccfr   <Esc>:call C_InsertTemplate("comment.frame")<CR>
inoremap    <buffer>  <silent>  <Leader>ccfu   <Esc>:call C_InsertTemplate("comment.function")<CR>
inoremap    <buffer>  <silent>  <Leader>ccme   <Esc>:call C_InsertTemplate("comment.method")<CR>
inoremap    <buffer>  <silent>  <Leader>cccl   <Esc>:call C_InsertTemplate("comment.class")<CR>

 noremap    <buffer>  <silent>  <Leader>ccd    a<C-R>=C_InsertDateAndTime('d')<CR>
inoremap    <buffer>  <silent>  <Leader>ccd     <C-R>=C_InsertDateAndTime('d')<CR>
 noremap    <buffer>  <silent>  <Leader>cct    a<C-R>=C_InsertDateAndTime('dt')<CR>
inoremap    <buffer>  <silent>  <Leader>cct     <C-R>=C_InsertDateAndTime('dt')<CR>
"
" ---------- statements menu  ------------------------------------------------
"
 noremap    <buffer>  <silent>  <Leader>csd         :call C_InsertTemplate("statements.do-while")<CR>
vnoremap    <buffer>  <silent>  <Leader>csd    <Esc>:call C_InsertTemplate("statements.do-while", "v")<CR>
inoremap    <buffer>  <silent>  <Leader>csd    <Esc>:call C_InsertTemplate("statements.do-while")<CR>

 noremap    <buffer>  <silent>  <Leader>csf         :call C_InsertTemplate("statements.for")<CR>
inoremap    <buffer>  <silent>  <Leader>csf    <Esc>:call C_InsertTemplate("statements.for")<CR>

 noremap    <buffer>  <silent>  <Leader>csfo        :call C_InsertTemplate("statements.for-block")<CR>
vnoremap    <buffer>  <silent>  <Leader>csfo   <Esc>:call C_InsertTemplate("statements.for-block", "v")<CR>
inoremap    <buffer>  <silent>  <Leader>csfo   <Esc>:call C_InsertTemplate("statements.for-block")<CR>

 noremap    <buffer>  <silent>  <Leader>csi         :call C_InsertTemplate("statements.if")<CR>
inoremap    <buffer>  <silent>  <Leader>csi    <Esc>:call C_InsertTemplate("statements.if")<CR>

 noremap    <buffer>  <silent>  <Leader>csif        :call C_InsertTemplate("statements.if-block")<CR>
vnoremap    <buffer>  <silent>  <Leader>csif   <Esc>:call C_InsertTemplate("statements.if-block", "v")<CR>
inoremap    <buffer>  <silent>  <Leader>csif   <Esc>:call C_InsertTemplate("statements.if-block")<CR>

 noremap    <buffer>  <silent>  <Leader>csie        :call C_InsertTemplate("statements.if-else")<CR>
vnoremap    <buffer>  <silent>  <Leader>csie   <Esc>:call C_InsertTemplate("statements.if-else", "v")<CR>
inoremap    <buffer>  <silent>  <Leader>csie   <Esc>:call C_InsertTemplate("statements.if-else")<CR>

 noremap    <buffer>  <silent>  <Leader>csife       :call C_InsertTemplate("statements.if-block-else")<CR>
vnoremap    <buffer>  <silent>  <Leader>csife  <Esc>:call C_InsertTemplate("statements.if-block-else", "v")<CR>
inoremap    <buffer>  <silent>  <Leader>csife  <Esc>:call C_InsertTemplate("statements.if-block-else")<CR>

 noremap    <buffer>  <silent>  <Leader>csw         :call C_InsertTemplate("statements.while")<CR>
inoremap    <buffer>  <silent>  <Leader>csw    <Esc>:call C_InsertTemplate("statements.while")<CR>

 noremap    <buffer>  <silent>  <Leader>cswh        :call C_InsertTemplate("statements.while-block")<CR>
vnoremap    <buffer>  <silent>  <Leader>cswh   <Esc>:call C_InsertTemplate("statements.while-block", "v")<CR>
inoremap    <buffer>  <silent>  <Leader>cswh   <Esc>:call C_InsertTemplate("statements.while-block")<CR>

 noremap    <buffer>  <silent>  <Leader>css         :call C_InsertTemplate("statements.switch")<CR>
vnoremap    <buffer>  <silent>  <Leader>css    <Esc>:call C_InsertTemplate("statements.switch", "v")<CR>
inoremap    <buffer>  <silent>  <Leader>css    <Esc>:call C_InsertTemplate("statements.switch")<CR>

 noremap    <buffer>  <silent>  <Leader>csc         :call C_InsertTemplate("statements.case")<CR>
inoremap    <buffer>  <silent>  <Leader>csc    <Esc>:call C_InsertTemplate("statements.case")<CR>

 noremap    <buffer>  <silent>  <Leader>cs{         :call C_InsertTemplate("statements.block")<CR>
vnoremap    <buffer>  <silent>  <Leader>cs{    <Esc>:call C_InsertTemplate("statements.block", "v")<CR>
inoremap    <buffer>  <silent>  <Leader>cs{    <Esc>:call C_InsertTemplate("statements.block")<CR>
"
" ---------- preprocessor menu  ----------------------------------------------
"
 noremap    <buffer>  <silent>  <Leader>cp<        :call C_InsertTemplate("preprocessor.include-global")<CR>
 noremap    <buffer>  <silent>  <Leader>cp"        :call C_InsertTemplate("preprocessor.include-local")<CR>
 noremap    <buffer>  <silent>  <Leader>cpd        :call C_InsertTemplate("preprocessor.define")<CR>
 noremap    <buffer>  <silent>  <Leader>cpu        :call C_InsertTemplate("preprocessor.undefine")<CR>
"
inoremap    <buffer>  <silent>  <Leader>cp<   <Esc>:call C_InsertTemplate("preprocessor.include-global")<CR>
inoremap    <buffer>  <silent>  <Leader>cp"   <Esc>:call C_InsertTemplate("preprocessor.include-local")<CR>
inoremap    <buffer>  <silent>  <Leader>cpd   <Esc>:call C_InsertTemplate("preprocessor.define")<CR>
inoremap    <buffer>  <silent>  <Leader>cpu   <Esc>:call C_InsertTemplate("preprocessor.undefine")<CR>

 noremap    <buffer>  <silent>  <Leader>cpie       :call C_InsertTemplate("preprocessor.if-else-endif")<CR>
 noremap    <buffer>  <silent>  <Leader>cpid       :call C_InsertTemplate("preprocessor.ifdef-else-endif")<CR>
 noremap    <buffer>  <silent>  <Leader>cpin       :call C_InsertTemplate("preprocessor.ifndef-else-endif")<CR>
 noremap    <buffer>  <silent>  <Leader>cpind      :call C_InsertTemplate("preprocessor.ifndef-def-endif")<CR>

vnoremap    <buffer>  <silent>  <Leader>cpie  <Esc>:call C_InsertTemplate("preprocessor.if-else-endif", "v")<CR>
vnoremap    <buffer>  <silent>  <Leader>cpid  <Esc>:call C_InsertTemplate("preprocessor.ifdef-else-endif", "v")<CR>
vnoremap    <buffer>  <silent>  <Leader>cpin  <Esc>:call C_InsertTemplate("preprocessor.ifndef-else-endif", "v")<CR>
vnoremap    <buffer>  <silent>  <Leader>cpind <Esc>:call C_InsertTemplate("preprocessor.ifndef-def-endif", "v")<CR>
                                     
inoremap    <buffer>  <silent>  <Leader>cpie  <Esc>:call C_InsertTemplate("preprocessor.if-else-endif")<CR>
inoremap    <buffer>  <silent>  <Leader>cpid  <Esc>:call C_InsertTemplate("preprocessor.ifdef-else-endif")<CR>
inoremap    <buffer>  <silent>  <Leader>cpin  <Esc>:call C_InsertTemplate("preprocessor.ifndef-else-endif")<CR>
inoremap    <buffer>  <silent>  <Leader>cpind <Esc>:call C_InsertTemplate("preprocessor.ifndef-def-endif")<CR>

 noremap    <buffer>  <silent>  <Leader>cpi0       :call C_PPIf0("a")<CR>2ji
inoremap    <buffer>  <silent>  <Leader>cpi0  <Esc>:call C_PPIf0("a")<CR>2ji
vnoremap    <buffer>  <silent>  <Leader>cpi0  <Esc>:call C_PPIf0("v")<CR>

 noremap    <buffer>  <silent>  <Leader>cpr0       :call C_PPIf0Remove()<CR>
inoremap    <buffer>  <silent>  <Leader>cpr0  <Esc>:call C_PPIf0Remove()<CR>
"
 noremap    <buffer>  <silent>  <Leader>cpe        :call C_InsertTemplate("preprocessor.error")<CR>
 noremap    <buffer>  <silent>  <Leader>cpl        :call C_InsertTemplate("preprocessor.line")<CR>
 noremap    <buffer>  <silent>  <Leader>cpp        :call C_InsertTemplate("preprocessor.pragma")<CR>
"
inoremap    <buffer>  <silent>  <Leader>cpe   <Esc>:call C_InsertTemplate("preprocessor.error")<CR>
inoremap    <buffer>  <silent>  <Leader>cpl   <Esc>:call C_InsertTemplate("preprocessor.line")<CR>
inoremap    <buffer>  <silent>  <Leader>cpp   <Esc>:call C_InsertTemplate("preprocessor.pragma")<CR>
"
" ---------- idioms menu  ----------------------------------------------------
"
 noremap    <buffer>  <silent>  <Leader>cif         :call C_InsertTemplate("idioms.function")<CR>
vnoremap    <buffer>  <silent>  <Leader>cif    <Esc>:call C_InsertTemplate("idioms.function", "v")<CR>
inoremap    <buffer>  <silent>  <Leader>cif    <Esc>:call C_InsertTemplate("idioms.function")<CR>
 noremap    <buffer>  <silent>  <Leader>cisf        :call C_InsertTemplate("idioms.function-static")<CR>
vnoremap    <buffer>  <silent>  <Leader>cisf   <Esc>:call C_InsertTemplate("idioms.function-static", "v")<CR>
inoremap    <buffer>  <silent>  <Leader>cisf   <Esc>:call C_InsertTemplate("idioms.function-static")<CR>
 noremap    <buffer>  <silent>  <Leader>cim         :call C_InsertTemplate("idioms.main")<CR>
vnoremap    <buffer>  <silent>  <Leader>cim    <Esc>:call C_InsertTemplate("idioms.main", "v")<CR>
inoremap    <buffer>  <silent>  <Leader>cim    <Esc>:call C_InsertTemplate("idioms.main")<CR>
"
 noremap    <buffer>  <silent>  <Leader>ci0         :call C_CodeFor("up"  , "a")<CR>a
vnoremap    <buffer>  <silent>  <Leader>ci0    <Esc>:call C_CodeFor("up"  , "v")<CR>
inoremap    <buffer>  <silent>  <Leader>ci0    <Esc>:call C_CodeFor("up"  , "a")<CR>a
 noremap    <buffer>  <silent>  <Leader>cin         :call C_CodeFor("down", "a")<CR>a
vnoremap    <buffer>  <silent>  <Leader>cin    <Esc>:call C_CodeFor("down", "v")<CR>
inoremap    <buffer>  <silent>  <Leader>cin    <Esc>:call C_CodeFor("down", "a")<CR>a
"
 noremap    <buffer>  <silent>  <Leader>cie         :call C_InsertTemplate("idioms.enum")<CR>
vnoremap    <buffer>  <silent>  <Leader>cie    <Esc>:call C_InsertTemplate("idioms.enum"  , "v")<CR>
inoremap    <buffer>  <silent>  <Leader>cie    <Esc>:call C_InsertTemplate("idioms.enum")<CR>
 noremap    <buffer>  <silent>  <Leader>cis         :call C_InsertTemplate("idioms.struct")<CR>
vnoremap    <buffer>  <silent>  <Leader>cis    <Esc>:call C_InsertTemplate("idioms.struct", "v")<CR>
inoremap    <buffer>  <silent>  <Leader>cis    <Esc>:call C_InsertTemplate("idioms.struct")<CR>
 noremap    <buffer>  <silent>  <Leader>ciu         :call C_InsertTemplate("idioms.union")<CR>
vnoremap    <buffer>  <silent>  <Leader>ciu    <Esc>:call C_InsertTemplate("idioms.union" , "v")<CR>
inoremap    <buffer>  <silent>  <Leader>ciu    <Esc>:call C_InsertTemplate("idioms.union")<CR>
"
 noremap    <buffer>  <silent>  <Leader>cip         :call C_InsertTemplate("idioms.printf")<CR>
inoremap    <buffer>  <silent>  <Leader>cip    <Esc>:call C_InsertTemplate("idioms.printf")<CR>
 noremap    <buffer>  <silent>  <Leader>cisc        :call C_InsertTemplate("idioms.scanf")<CR>
inoremap    <buffer>  <silent>  <Leader>cisc   <Esc>:call C_InsertTemplate("idioms.scanf")<CR>
"
 noremap    <buffer>  <silent>  <Leader>cica        :call C_InsertTemplate("idioms.calloc")
inoremap    <buffer>  <silent>  <Leader>cica   <Esc>:call C_InsertTemplate("idioms.calloc")
 noremap    <buffer>  <silent>  <Leader>cima        :call C_InsertTemplate("idioms.malloc")<CR>
inoremap    <buffer>  <silent>  <Leader>cima   <Esc>:call C_InsertTemplate("idioms.malloc")<CR>
"
 noremap    <buffer>  <silent>  <Leader>cisi        :call C_InsertTemplate("idioms.sizeof")<CR>
inoremap    <buffer>  <silent>  <Leader>cisi   <Esc>:call C_InsertTemplate("idioms.sizeof")<CR>
vnoremap    <buffer>  <silent>  <Leader>cisi   <Esc>:call C_InsertTemplate("idioms.sizeof", "v")<CR>

 noremap    <buffer>  <silent>  <Leader>cias        :call C_InsertTemplate("idioms.assert")<CR>
vnoremap    <buffer>  <silent>  <Leader>cias   <Esc>:call C_InsertTemplate("idioms.assert", "v")<CR>
inoremap    <buffer>  <silent>  <Leader>cias   <Esc>:call C_InsertTemplate("idioms.assert")<CR>
"
 noremap    <buffer>  <silent>  <Leader>cii         :call C_InsertTemplate("idioms.open-input-file")<CR>
inoremap    <buffer>  <silent>  <Leader>cii    <Esc>:call C_InsertTemplate("idioms.open-input-file")<CR>
vnoremap    <buffer>  <silent>  <Leader>cii    <Esc>:call C_InsertTemplate("idioms.open-input-file", "v")<CR>
 noremap    <buffer>  <silent>  <Leader>cio         :call C_InsertTemplate("idioms.open-output-file")<CR>
inoremap    <buffer>  <silent>  <Leader>cio    <Esc>:call C_InsertTemplate("idioms.open-output-file")<CR>
vnoremap    <buffer>  <silent>  <Leader>cio    <Esc>:call C_InsertTemplate("idioms.open-output-file", "v")<CR>
"
" ---------- snippet menu ----------------------------------------------------
"
 noremap    <buffer>  <silent>  <Leader>cnr         :call C_CodeSnippet("r")<CR>
 noremap    <buffer>  <silent>  <Leader>cnw         :call C_CodeSnippet("w")<CR>
vnoremap    <buffer>  <silent>  <Leader>cnw    <Esc>:call C_CodeSnippet("wv")<CR>
 noremap    <buffer>  <silent>  <Leader>cne         :call C_CodeSnippet("e")<CR>
"
 noremap    <buffer>  <silent>  <Leader>cnp         :call C_ProtoPick("n")<CR>
vnoremap    <buffer>  <silent>  <Leader>cnp    <Esc>:call C_ProtoPick("v")<CR>
 noremap    <buffer>  <silent>  <Leader>cni         :call C_ProtoInsert()<CR>
 noremap    <buffer>  <silent>  <Leader>cnc         :call C_ProtoClear()<CR>
 noremap    <buffer>  <silent>  <Leader>cns         :call C_ProtoShow()<CR>
"
 noremap    <buffer>  <silent>  <Leader>cntl        :call C_EditTemplates("local")<CR>
 noremap    <buffer>  <silent>  <Leader>cntg        :call C_EditTemplates("global")<CR>
 noremap    <buffer>  <silent>  <Leader>cntr        :call C_RebuildTemplates()<CR>
"
" ---------- C++ menu ----------------------------------------------------
"
 noremap    <buffer>  <silent>  <Leader>c+c         :call C_InsertTemplate("cpp.class-definition")<CR>
inoremap    <buffer>  <silent>  <Leader>c+c    <Esc>:call C_InsertTemplate("cpp.class-definition")<CR>
 noremap    <buffer>  <silent>  <Leader>c+cn        :call C_InsertTemplate("cpp.class-using-new-definition")<CR>
inoremap    <buffer>  <silent>  <Leader>c+cn   <Esc>:call C_InsertTemplate("cpp.class-using-new-definition")<CR>

 noremap    <buffer>  <silent>  <Leader>c+ci        :call C_InsertTemplate("cpp.class-implementation")<CR>
inoremap    <buffer>  <silent>  <Leader>c+ci   <Esc>:call C_InsertTemplate("cpp.class-implementation")<CR>
 noremap    <buffer>  <silent>  <Leader>c+cni       :call C_InsertTemplate("cpp.class-using-new-implementation")<CR>
inoremap    <buffer>  <silent>  <Leader>c+cni  <Esc>:call C_InsertTemplate("cpp.class-using-new-implementation")<CR>

 noremap    <buffer>  <silent>  <Leader>c+mi        :call C_InsertTemplate("cpp.method-implementation")<CR>
inoremap    <buffer>  <silent>  <Leader>c+mi   <Esc>:call C_InsertTemplate("cpp.method-implementation")<CR>
 noremap    <buffer>  <silent>  <Leader>c+ai        :call C_InsertTemplate("cpp.accessor-implementation")<CR>
inoremap    <buffer>  <silent>  <Leader>c+ai   <Esc>:call C_InsertTemplate("cpp.accessor-implementation")<CR>

 noremap    <buffer>  <silent>  <Leader>c+tc        :call C_InsertTemplate("cpp.template-class-definition")<CR>
inoremap    <buffer>  <silent>  <Leader>c+tc   <Esc>:call C_InsertTemplate("cpp.template-class-definition")<CR>
 noremap    <buffer>  <silent>  <Leader>c+tcn       :call C_InsertTemplate("cpp.template-class-using-new-definition")<CR>
inoremap    <buffer>  <silent>  <Leader>c+tcn  <Esc>:call C_InsertTemplate("cpp.template-class-using-new-definition")<CR>

 noremap    <buffer>  <silent>  <Leader>c+tci       :call C_InsertTemplate("cpp.template-class-implementation")<CR>
inoremap    <buffer>  <silent>  <Leader>c+tci  <Esc>:call C_InsertTemplate("cpp.template-class-implementation")<CR>
 noremap    <buffer>  <silent>  <Leader>c+tcni      :call C_InsertTemplate("cpp.template-class-using-new-implementation")<CR>
inoremap    <buffer>  <silent>  <Leader>c+tcni <Esc>:call C_InsertTemplate("cpp.template-class-using-new-implementation")<CR>

 noremap    <buffer>  <silent>  <Leader>c+tmi       :call C_InsertTemplate("cpp.template-method-implementation")<CR>
inoremap    <buffer>  <silent>  <Leader>c+tmi  <Esc>:call C_InsertTemplate("cpp.template-method-implementation")<CR>
 noremap    <buffer>  <silent>  <Leader>c+tai       :call C_InsertTemplate("cpp.template-accessor-implementation")<CR>
inoremap    <buffer>  <silent>  <Leader>c+tai  <Esc>:call C_InsertTemplate("cpp.template-accessor-implementation")<CR>

 noremap    <buffer>  <silent>  <Leader>c+tf        :call C_InsertTemplate("cpp.template-function")<CR>
inoremap    <buffer>  <silent>  <Leader>c+tf   <Esc>:call C_InsertTemplate("cpp.template-function")<CR>

 noremap    <buffer>  <silent>  <Leader>c+ec        :call C_InsertTemplate("cpp.error-class")<CR>
inoremap    <buffer>  <silent>  <Leader>c+ec   <Esc>:call C_InsertTemplate("cpp.error-class")<CR>

 noremap    <buffer>  <silent>  <Leader>c+tr        :call C_InsertTemplate("cpp.try-catch")<CR>
vnoremap    <buffer>  <silent>  <Leader>c+tr   <Esc>:call C_InsertTemplate("cpp.try-catch", "v")<CR>
inoremap    <buffer>  <silent>  <Leader>c+tr   <Esc>:call C_InsertTemplate("cpp.try-catch")<CR>

 noremap    <buffer>  <silent>  <Leader>c+ca        :call C_InsertTemplate("cpp.catch")<CR>
vnoremap    <buffer>  <silent>  <Leader>c+ca   <Esc>:call C_InsertTemplate("cpp.catch", "v")<CR>
inoremap    <buffer>  <silent>  <Leader>c+ca   <Esc>:call C_InsertTemplate("cpp.catch")<CR>

 noremap    <buffer>  <silent>  <Leader>c+c.        :call C_InsertTemplate("cpp.catch-points")<CR>
vnoremap    <buffer>  <silent>  <Leader>c+c.   <Esc>:call C_InsertTemplate("cpp.catch-points", "v")<CR>
inoremap    <buffer>  <silent>  <Leader>c+c.   <Esc>:call C_InsertTemplate("cpp.catch-points")<CR>
"
" ---------- run menu --------------------------------------------------------
"
 map    <buffer>  <silent>  <Leader>crc         :call C_Compile()<CR>:redraw<CR>:call C_HlMessage()<CR>
 map    <buffer>  <silent>  <Leader>crl         :call C_Link()<CR>:redraw<CR>:call C_HlMessage()<CR>
 map    <buffer>  <silent>  <Leader>crr         :call C_Run()<CR>
 map    <buffer>  <silent>  <Leader>cra         :call C_Arguments()<CR>
 map    <buffer>  <silent>  <Leader>crm         :call C_Make()<CR>
 map    <buffer>  <silent>  <Leader>crg         :call C_MakeArguments()<CR>
 map    <buffer>  <silent>  <Leader>crp         :call C_SplintCheck()<CR>:redraw<CR>:call C_HlMessage()<CR>
 map    <buffer>  <silent>  <Leader>cri         :call C_SplintArguments()<CR>
 map    <buffer>  <silent>  <Leader>crd         :call C_Indent("a")<CR>:redraw<CR>:call C_HlMessage()<CR>
 map    <buffer>  <silent>  <Leader>crh         :call C_Hardcopy("n")<CR>
 map    <buffer>  <silent>  <Leader>crs         :call C_Settings()<CR>
"
vmap    <buffer>  <silent>  <Leader>crd    <C-C>:call C_Indent("v")<CR>:redraw<CR>:call C_HlMessage()<CR>
vmap    <buffer>  <silent>  <Leader>crh    <C-C>:call C_Hardcopy("v")<CR>
"
imap    <buffer>  <silent>  <Leader>crc    <C-C>:call C_Compile()<CR>:redraw<CR>:call C_HlMessage()<CR>
imap    <buffer>  <silent>  <Leader>crl    <C-C>:call C_Link()<CR>:redraw<CR>:call C_HlMessage()<CR>
imap    <buffer>  <silent>  <Leader>crr    <C-C>:call C_Run()<CR>
imap    <buffer>  <silent>  <Leader>cra    <C-C>:call C_Arguments()<CR>
imap    <buffer>  <silent>  <Leader>crm    <C-C>:call C_Make()<CR>
imap    <buffer>  <silent>  <Leader>crg    <C-C>:call C_MakeArguments()<CR>
imap    <buffer>  <silent>  <Leader>crp    <C-C>:call C_SplintCheck()<CR>:redraw<CR>:call C_HlMessage()<CR>
imap    <buffer>  <silent>  <Leader>cri    <C-C>:call C_SplintArguments()<CR>
imap    <buffer>  <silent>  <Leader>crd    <C-C>:call C_Indent("a")<CR>:redraw<CR>:call C_HlMessage()<CR>
imap    <buffer>  <silent>  <Leader>crh    <C-C>:call C_Hardcopy("n")<CR>
imap    <buffer>  <silent>  <Leader>crs    <C-C>:call C_Settings()<CR>
 if has("unix")
   map    <buffer>  <silent>  <Leader>crx         :call C_XtermSize()<CR>
  imap    <buffer>  <silent>  <Leader>crx    <C-C>:call C_XtermSize()<CR>
 endif
 map    <buffer>  <silent>  <Leader>cro         :call C_Toggle_Gvim_Xterm()<CR>
imap    <buffer>  <silent>  <Leader>cro    <C-C>:call C_Toggle_Gvim_Xterm()<CR>
"
" Abraxas CodeCheck (R)
"
if executable("check") 
  map    <buffer>  <silent>  <Leader>crk         :call C_CodeCheck()<CR>:redraw<CR>:call C_HlMessage()<CR>
  map    <buffer>  <silent>  <Leader>cre         :call C_CodeCheckArguments()<CR>
 imap    <buffer>  <silent>  <Leader>crk    <C-C>:call C_CodeCheck()<CR>:redraw<CR>:call C_HlMessage()<CR>
 imap    <buffer>  <silent>  <Leader>cre    <C-C>:call C_CodeCheckArguments()<CR>
endif
" ---------- plugin help -----------------------------------------------------
"
 map    <buffer>  <silent>  <Leader>ch         :call C_HelpCsupport()<CR>
imap    <buffer>  <silent>  <Leader>ch    <C-C>:call C_HelpCsupport()<CR>
"
