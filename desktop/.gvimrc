"
" big .gvimrc -- this is where I put vim customizations
"

set mouse=a

"
" Pathogen plug-in manager
"  mkdir -p ~/.vim/{autoload,bundle}
"  cd ~/.vim/autoload && wget https://tpo.pe/pathogen.vim
"
" clone repos into .vim/bundle
" Remember to run :Helptags to generate help tags
"
"if filereadable(glob("$HOME/.vim/autoload/pathogen.vim"))
if has("pathogen")
  execute pathogen#infect()
endif

colorscheme murphy

if has("autocmd")
  autocmd BufEnter *.py set ai tw=79 tabstop=4 shiftwidth=4 softtabstop=4 sta fo=croql 
  if filereadable(glob("$HOME/.vim/templates"))
    autocmd BufNewFile * silent! 0r $HOME/.vim/templates/%:e
  endif
endif


syntax enable


if filereadable(glob("$HOME/.vim/views"))
  set viewdir=$HOME/.vim/views
endif

"
" cd ~/.vim/bundle
" git clone https://github.com/vim-airline/vim-airline
" git clone https://github.com/vim-airline/vim-airline-themes
"

set laststatus=2
let g:airline_theme='dark'
"let g:airline_theme='base16'
"let g:airline_powerline_fonts=1

set cursorline cursorcolumn
"set guitabtooltip=%!bufname($)
set ve=


if has("gui_gtk3")
  " Newer Linux systems
  set guifont=Ubuntu\ Mono\ 12
" set guifont=RobotoMono\ Nerd\ Font\ Medium\ 12
elseif has("gui_gtk2")
  " Older Linux systems
  set guifont=Inconsolata\ 12
elseif has("gui_macvim")
  set guifont=Menlo\ Regular:h14
elseif has("gui_win32")
  set guifont=Consolas\ Bold:h14:cANSI
endif

" set guifont=FantasqueSansMono\ Nerd\ Font\ 13
" set guifont=UbuntuMonoDerivativePowerline\ Nerd\ Font\ 15
" set guifont=DejaVuSansMonoForPowerline\ Nerd\ Font\ 11
" set guifont=InconsolataForPowerline\ Nerd\ Font\ Medium\ 12
" set guifont=MesloLGS\ Nerd\ Font\ 11
" set guifont=Hurmit\ Nerd\ Font\ Medium\ 12
" set guifont=MonofurForPowerline\ Nerd\ Font\ 12
" set guifont=3270Medium\ Nerd\ Font\ Medium\ 14

