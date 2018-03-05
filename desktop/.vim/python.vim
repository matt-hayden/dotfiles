"
" http://sontek.net/blog/detail/turning-vim-into-a-modern-python-ide
" This will complain if pathogen isn't installed. Download pathogen to 
" vimfiles/autoload for either the system or the user.
" http://www.vim.org/scripts/script.php?script_id=2332
"
filetype off
call pathogen#runtime_append_all_bundles()
call pathogen#helptags()

" in .vim: git init bundle
" in .vim/bundle:
" git submodule add git://github.com/tpope/vim-fugitive.git bundle/fugitive
" git submodule add git://github.com/sjl/gundo.vim bundle/gundo

set foldmethod=indent
set foldlevel=99

map <leader>td <Plug>TaskList
map <leader>g :GundoToggle<CR>
