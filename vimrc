" UI
colorscheme molokai
set ruler

" Swap files
set directory=$HOME/.vim/swpfiles//

" Undo
set undodir=$HOME/.vim/undodir
set undofile
set undolevels=1000
set undoreload=10000

" Syntax
syntax on
filetype on
filetype indent on
filetype plugin on

" Indentation
set tabstop=4
set shiftwidth=4
set expandtab

" Search
set hlsearch
set incsearch
set ignorecase

" Keyboard shortcuts
map <F12> :set lines=80 columns=192<CR>
map <S-F12> :set lines=40 columns=96<CR>

