set visualbell
nmap <F1> <nop>

" Don't reload network files when switching buffers:
set bufhidden=hide

" Personal preferences
set hlsearch number showcmd


syntax enable
function! ToggleSyntax()
   if exists("g:syntax_on")
      syntax off
   else
      syntax enable
   endif
endfunction
nmap <silent>  ;s  :call ToggleSyntax()<CR>


" Allows the backspace to delete indenting, end of lines, and over the start
" of insert
set backspace=indent,eol,start

" J joins lines... K splits lines
nnoremap K s<CR><Esc>

set viewdir=$HOME/.vim/views
