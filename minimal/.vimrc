"
" small vimrc -- I tend to put most customization in gvimrc
"

" VIMHOME = split(&runtimepath,',')[0]


set nocompatible
set modelines=4

if !has("gui")
  set visualbell
  set wrap
  set textwidth=79
  set formatoptions=qrn1
  set colorcolumn=80
  
  set bg=dark
  " console tabline if using airline
  let g:airline#extensions#tabline#enabled=1
  if 2 < &t_Co
    set hlsearch
"    colorscheme desert
    syntax enable
  endif
endif

nmap <F1> <nop>

" Don't reload network files when switching buffers:
set bufhidden=hide

" Personal preferences
set mousehide number showcmd showmatch scs shortmess=a
set wildmenu lazyredraw

if has("autocmd")
  let g:airline_detect_crypt=1

  filetype plugin on
  filetype plugin indent on
endif

" Key bindings {{{
" + is a pretty useless movement command
let mapleader="+"

function! ToggleSyntax()
   if exists("g:syntax_on")
      syntax off
   else
      syntax enable
   endif
endfunction

" move to beginning/end of line. B=b and E=e by default which is silly
nnoremap B ^
nnoremap E $


" move vertically by visual line
nnoremap j gj
nnoremap k gk

nmap <leader>d  :r!date<CR>
nmap <leader>gV	`[v`]
nmap <leader>s  :call ToggleSyntax()<CR>
nmap <leader>S  :%!gpg2 --clearsign<CR>
nmap <leader>u	:GundoToggle<CR>


" Allows the backspace to delete indenting, end of lines, and over the start
" of insert
set backspace=indent,eol,start

" J joins lines... K splits lines, overriding a nasty builtin
nnoremap K s<CR><Esc>

nnoremap <silent> <C-Up>    :tabnew<CR>
nnoremap <silent> <C-Left>  :tabnext<CR>
nnoremap <silent> <C-Right> :tabprev<CR>

" }}}

" Load the result of mksession!
if filereadable(glob("Session.vim")) 
  source Session.vim
endif

" vim:foldmethod=marker:foldlevel=0
