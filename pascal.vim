set background=dark
highlight clear
if exists ("syntax_on")
	syntax reset
endif
let g:colors_name = "oswaldo"
set t_Co=256
highlight Normal ctermbg=19


hi Normal 	term=BOLD cterm=BOLD ctermfg=Yellow ctermbg=19
hi Normal 	gui=BOLD guifg=Yellow guibg=19
hi NonText 	term=NONE cterm=NONE ctermfg=White ctermbg=19
hi NonText 	gui=NONE guifg=White guibg=19

hi Statement 	term=BOLD cterm=BOLD ctermfg=White ctermbg=19
hi Statement 	gui=BOLD guifg=White guibg=19
hi Special 	term=NONE cterm=NONE ctermfg=Cyan ctermbg=19
hi Special 	gui=NONE guifg=Cyan guibg=19
hi Constant 	term=NONE cterm=NONE ctermfg=Magenta ctermbg=19
hi Constant	gui=NONE guifg=Magenta guibg=19
hi Comment 	term=BOLD cterm=BOLD ctermfg=Gray ctermbg=19
hi Comment 	gui=BOLD guifg=Gray guibg=19
hi Preproc 	term=BOLD cterm=BOLD ctermfg=Green ctermbg=19
hi Preproc 	gui=NONE guifg=Green guibg=DarkBlue
hi Type 	term=NONE cterm=NONE ctermfg=White ctermbg=19
hi Type 	gui=NONE guifg=White guibg=19
hi Identifier 	term=NONE cterm=NONE ctermfg=White ctermbg=19
hi Identifier 	gui=NONE guifg=White guibg=19

hi StatusLine	term=NONE cterm=NONE ctermfg=Black ctermbg=DarkCyan
hi StatusLine 	gui=NONE guifg=Black guibg=DarkCyan

hi StatusLineNC	term=NONE cterm=NONE ctermfg=Gray ctermbg=19
hi StatusLineNC	gui=NONE guifg=Gray guibg=19

hi Visual 	term=NONE cterm=NONE ctermbg=Gray 
hi Visual 	gui=NONE guibg=Gray 

hi Search 	term=NONE cterm=NONE ctermfg=Gray 
hi Search 	gui=NONE guifg=Gray 

hi VertSplit 	term=NONE cterm=NONE ctermfg=Black ctermbg=White
hi VertSplit 	gui=NONE guifg=Black guibg=White

hi Directory 	term=NONE cterm=NONE ctermfg=Green ctermbg=19
hi Directory 	gui=NONE guifg=Green guibg=19

hi WarningMsg 	term=standout cterm=NONE ctermfg=Red ctermbg=19
hi WarningMsg 	gui=standout guifg=Gray guibg=19

hi Error 	term=NONE cterm=NONE ctermfg=White ctermbg=Red
hi Error 	gui=NONE guifg=Gray guibg=19

hi CursorLine 	guifg=NONE guibg=Yellow
hi CursorLine 	ctermfg=Black ctermbg=Yellow
hi Cursor 	ctermfg=Black ctermbg=Yellow
hi Cursor 	guifg=Black guibg=Yellow
