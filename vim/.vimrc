if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

Plug 'ctrlpvim/ctrlp.vim'
Plug 'dylanaraps/wal.vim'
Plug 'editorconfig/editorconfig-vim'
Plug 'elixir-editors/vim-elixir'
Plug 'jiangmiao/auto-pairs'
Plug 'leafgarland/typescript-vim'
Plug 'mhinz/vim-signify'
Plug 'mxw/vim-jsx', { 'for': ['javascript'] }
Plug 'pangloss/vim-javascript'
Plug 'plasticboy/vim-markdown'
Plug 'prettier/vim-prettier'
Plug 'scrooloose/nerdtree'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'vim-airline/vim-airline'
Plug 'w0rp/ale'

call plug#end()

set nocompatible

set autoindent
set background=dark
set backspace=indent,eol,start
set expandtab
set hlsearch
set linebreak
set number
set ruler
set shell=/bin/zsh
set shiftwidth=2
set showcmd
set showmatch
set smartcase
set smartindent
set smarttab
set tabstop=2
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,node_modules

syntax on
filetype plugin indent on

colorscheme wal
au BufNewFile,BufRead /dev/shm/gopass.* setlocal noswapfile nobackup noundofile

