" activates syntax highlighting among other things
syntax on
set backspace=indent,eol,start
set nolist
highlight TrailingSpace ctermbg=red guibg=red
match TrailingSpace /\s\+$/
highlight Tabs ctermbg=gray ctermfg=DarkGray guibg=DarkGray
2match Tabs /\t/

