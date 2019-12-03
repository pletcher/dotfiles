if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

Plug 'airblade/vim-gitgutter'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'editorconfig/editorconfig-vim'
Plug 'elixir-editors/vim-elixir'
Plug 'jiangmiao/auto-pairs'
Plug 'leafgarland/typescript-vim'
Plug 'mxw/vim-jsx', { 'for': ['javascript'] }
Plug 'pangloss/vim-javascript'
Plug 'prettier/vim-prettier'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'w0rp/ale'

call plug#end()

set nocompatible

syntax on
filetype plugin indent on

" colorscheme wal

set autoindent
set backspace=indent,eol,start
set display=lastline
set expandtab
set hidden
set hlsearch
set incsearch
set laststatus=2
set linebreak
set report=0
set shell=/bin/zsh
set shiftround
set shiftwidth=2
set showcmd
set showmatch
set showmode
set smartcase
set smartindent
set smarttab
set softtabstop=2
set splitbelow
set splitright
set synmaxcol=100
set tabstop=2
set textwidth=0
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,node_modules
set wrap
set wrapscan

autocmd BufNewFile,BufFilePre,BufRead *.md set filetype=markdown.pandoc
autocmd FileType markdown.pandoc setlocal textwidth=80
autocmd FileType markdown.pandoc setlocal nowrap 

inoremap . .<C-g>u
inoremap ! !<C-g>u
inoremap ? ?<C-g>u
inoremap : :<C-g>u

nnoremap j gj
nnoremap k gk

let mapleader = ","

au BufNewFile,BufRead /dev/shm/gopass.* setlocal noswapfile nobackup noundofile

