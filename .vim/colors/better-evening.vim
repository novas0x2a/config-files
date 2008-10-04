" Vim color file
" Maintainer:	Mike Lundy <mike@fluffypenguin.org>
" Last Change:	2006 Oct 30

" First remove all existing highlighting.
set background=dark
hi clear
if exists("syntax_on")
  syntax reset
endif

let colors_name = "better-evening"

hi Type         ctermfg=DarkGreen ctermbg=Black   guifg=DarkGreen guibg=Black
hi Normal       ctermfg=White ctermbg=Black   guifg=White guibg=Black
hi ErrorMsg     ctermfg=White ctermbg=DarkRed guifg=White guibg=DarkRed
hi IncSearch    cterm=reverse                 gui=reverse
hi ModeMsg      cterm=bold                    gui=bold
hi StatusLine   cterm=reverse                 gui=reverse
hi StatusLineNC cterm=reverse                 gui=reverse
hi VertSplit    cterm=reverse                 gui=reverse
hi Visual       cterm=reverse ctermfg=Grey    gui=reverse guifg=Grey
hi VisualNOS    cterm=underline,bold          gui=underline,bold
hi DiffText     ctermbg=DarkRed               guibg=DarkRed
hi Cursor       cterm=reverse                 guifg=bg guibg=fg
hi Directory    ctermfg=Cyan                  guifg=Cyan
hi LineNr       ctermfg=Yellow                guifg=Yellow
hi MoreMsg      ctermfg=Green                 guifg=Green
hi NonText      ctermfg=Red                   guifg=Red
hi Question     ctermfg=Green                 guifg=Green
hi Search       ctermfg=Black ctermbg=Yellow  guifg=Black guifg=Yellow
hi SpecialKey   ctermfg=Red                   guifg=Red
hi Title        ctermfg=Magenta               guifg=Magenta
hi WarningMsg   ctermfg=Red                   guifg=Red
hi WildMenu     ctermfg=Black ctermbg=Yellow  guifg=Black guibg=Yellow
hi Folded       ctermfg=DarkBlue ctermbg=Grey guifg=DarkBlue guibg=Grey
hi FoldColumn   ctermfg=DarkBlue ctermbg=Grey guifg=DarkBlue guibg=Grey
hi DiffAdd      ctermbg=DarkBlue              guibg=DarkBlue
hi DiffChange   ctermbg=DarkMagenta           guibg=DarkMagenta
hi DiffDelete   ctermfg=Blue ctermbg=DarkCyan guifg=Blue guibg=DarkCyan
hi Comment      ctermfg=Cyan                  guifg=Cyan
hi Error        ctermbg=DarkRed               guibg=DarkRed
hi Constant     ctermfg=Magenta               guifg=Magenta
hi Special      ctermfg=Red                   guifg=Red
hi Statement    ctermfg=Yellow                guifg=Yellow
hi PreProc      ctermfg=Blue                  guifg=Blue
hi Identifier   ctermfg=14
hi MatchParen   cterm=underline,bold ctermbg=none gui=underline,bold
hi TabLineFill  cterm=none ctermbg=DarkGrey       gui=none
hi TabLine      cterm=none ctermfg=White ctermbg=DarkGrey  guifg=White
hi TabLineSel   cterm=bold ctermfg=Green ctermbg=DarkGrey    guifg=Red
hi Pmenu        ctermfg=Black ctermbg=Gray      guifg=Black guibg=Gray
hi PmenuSel     ctermfg=Green ctermbg=DarkGray  guifg=Green guibg=DarkGray
hi PmenuSbar    ctermfg=Black ctermbg=DarkGray  guifg=Black guibg=DarkGray

" vim: sw=2 ts=2
