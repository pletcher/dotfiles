if empty(glob("~/.local/share/nvim/site/autoload/plug.vim"))
  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source ~/.config/nvim/init.vim
endif

call plug#begin('~/.local/share/nvim/plugged')

Plug 'dylanaraps/wal.vim'
Plug 'editorconfig/editorconfig-vim'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'junegunn/goyo.vim'
Plug 'junegunn/limelight.vim'
Plug 'lervag/vimtex'
Plug 'pangloss/vim-javascript'
Plug 'plasticboy/vim-markdown'
Plug 'vim-airline/vim-airline'
Plug 'w0rp/ale'

call plug#end()


"Credit joshdick
"via https://github.com/rakr/vim-one
"Use 24-bit (true-color) mode in Vim/Neovim when outside tmux.
"If you're using tmux version 2.2 or later, you can remove the outermost $TMUX check and use tmux's 24-bit color support
"(see < http://sunaku.github.io/tmux-24bit-color.html#usage > for more information.)
if (empty($TMUX))
  if (has("nvim"))
  "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
		let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  endif
endif

let g:airline_detect_spell = 1
let g:airline_detect_spelllang = 1

let g:ale_lint_on_save = 1
let g:ale_lint_on_text_changed = 1

let g:javascript_plugin_flow = 1
let g:jsx_ext_required = 0

" let g:nord_comment_brightness = 12
" let g:nord_italic = 1
" let g:nord_italic_comments = 1
" let g:nord_underline = 1


set nocompatible

set autoindent
set background=dark
set backspace=indent,eol,start
set encoding=utf-8
set pastetoggle=<F10>
set smarttab
set shell=/bin/zsh
set shiftwidth=2
set tabstop=2
set tw=80

syntax on
filetype plugin indent on

colorscheme wal

au BufNewFile,BufRead /dev/shm/gopass.* setlocal noswapfile nobackup noundofile

