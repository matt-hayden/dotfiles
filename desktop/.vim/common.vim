set visualbell
nmap <F1> <nop>

" Don't reload network files when switching buffers:
set bufhidden=hide

" Personal preferences
set hlsearch number showcmd


" Pathogen plug-in manager
"  clone repos into .vim/bundle
"  Remember to run :Helptags to generate help tags
execute pathogen#infect()

syntax enable
function! ToggleSyntax()
   if exists("g:syntax_on")
      syntax off
   else
      syntax enable
   endif
endfunction
nmap <silent>  ;s  :call ToggleSyntax()<CR>


autocmd BufEnter *.py set ai tw=79 tabstop=4 shiftwidth=4 softtabstop=4 sta fo=croql 
autocmd BufNewFile * silent! 0r $VIMHOME/templates/%:e


" Allows the backspace to delete indenting, end of lines, and over the start
" of insert
set backspace=indent,eol,start

" J joins lines... K splits lines
nnoremap K s<CR><Esc>

nnoremap <silent> <C-Up> :tabnew<CR>
nnoremap <silent> <C-Left> :tabnext<CR>
nnoremap <silent> <C-Right> :tabprev<CR>


" Load the result of mksession!
if filereadable(glob("Session.vim")) 
  source Session.vim
endif

if filereadable(glob("~/.vimrc.local")) 
    source ~/.vimrc.local
endif
set viewdir=$HOME/.vim/views
