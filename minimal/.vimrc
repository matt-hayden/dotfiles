"
" small vimrc -- I tend to put most customization in gvimrc
"

" VIMHOME = split(&runtimepath,',')[0]

set nocompatible
set modelines=4

if !has("gui")
  set visualbell
  set bg=dark
  " console tabline if using airline
  let g:airline#extensions#tabline#enabled=1
  if 2 < &t_Co
    set hlsearch
    colorscheme desert
    syntax enable
  endif
endif

nmap <F1> <nop>

" Don't reload network files when switching buffers:
set bufhidden=hide

" Personal preferences
set mousehide number showcmd scs shortmess=a

if has("autocmd")
  let g:airline_detect_crypt=1

  filetype plugin on
  filetype plugin indent on
endif

function! ToggleSyntax()
   if exists("g:syntax_on")
      syntax off
   else
      syntax enable
   endif
endfunction


nmap <silent>  ;d  :r!date<CR>
nmap <silent>  ;s  :call ToggleSyntax()<CR>
nmap <silent>  ;S  :%!gpg2 --clearsign<CR>


" Allows the backspace to delete indenting, end of lines, and over the start
" of insert
set backspace=indent,eol,start

" J joins lines... K splits lines, overriding a nasty builtin
nnoremap K s<CR><Esc>

nnoremap <silent> <C-Up>    :tabnew<CR>
nnoremap <silent> <C-Left>  :tabnext<CR>
nnoremap <silent> <C-Right> :tabprev<CR>


" Load the result of mksession!
if filereadable(glob("Session.vim")) 
  source Session.vim
endif

