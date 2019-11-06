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
Plug 'junegunn/goyo.vim' 
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
" Plug 'vim-pandoc/vim-pandoc'
" Plug 'vim-pandoc/vim-pandoc-syntax'
Plug 'w0rp/ale'

call plug#end()

set nocompatible

colorscheme wal

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
set textwidth=0
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,node_modules
set wrap

syntax on
filetype plugin indent on

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

let g:vim_markdown_auto_insert_bullets = 0
let g:vim_markdown_frontmatter = 1
let g:vim_markdown_new_list_item_indent = 0
let g:vim_markdown_strikethrough = 1

au BufNewFile,BufRead /dev/shm/gopass.* setlocal noswapfile nobackup noundofile

