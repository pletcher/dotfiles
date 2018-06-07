call plug#begin('~/.vim/plugged')

Plug 'editorconfig/editorconfig-vim'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'pangloss/vim-javascript'
Plug 'w0rp/ale'

call plug#end()

let g:ale_lint_on_save = 1
let g:ale_lint_on_text_changed = 1

let g:javascript_plugin_flow = 1
let g:jsx_ext_required = 0

set nocompatible

set autoindent
set backspace=indent,eol,start
set encoding=utf-8
set pastetoggle=<F10>
set smarttab
set shell=/bin/zsh
set shiftwidth=2
set t_Co=16
set tabstop=2

syntax on
filetype plugin indent on
