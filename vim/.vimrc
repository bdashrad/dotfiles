" make vim more useful
set nocompatible

" enable syntax highlighting
syntax enable
set encoding=utf-8 nobomb
set t_Co=256
set background=dark

" Local dirs
set backupdir=~/.vim/backups
set directory=~/.vim/swaps
set undodir=~/.vim/undo

set autoindent " Copy indent from last line when starting new line.
set smartindent
set cursorline " Highlight current line
set expandtab
set tabstop=2
set shiftwidth=2
set diffopt=filler " Add vertical spaces to keep right and left aligned
set hidden " leave buffers open with unsaved changes when opening new files
set hlsearch " Highlight searches
set history=1000 " command history length
set number " enable line numbers
set title  " Show the filename in the window titlebar.
set ruler" show cursor position
set visualbell
set undofile " Persistent Undo.
set backspace=indent,eol,start

" command tab completion
set wildmenu
set wildmode=list:longest

" Paste Mode
nnoremap <F8> :set invpaste paste?<CR>
set pastetoggle=<F8>
set showmode  " Show the current mode.

" map w!! to allow writing to files with sudo
cnoremap w!! w !sudo tee > /dev/null %

" Plugins -------------------------------------------------------------

" Load plugins {{{
call plug#begin('~/.vim/plugged')

Plug 'joker1007/vim-ruby-heredoc-syntax'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/vim-easy-align'
Plug 'rking/ag.vim'
Plug 'thoughtbot/vim-rspec'
Plug 'tpope/vim-markdown',     { 'for': 'markdown' }
Plug 'vim-scripts/ingo-library',
Plug 'vim-scripts/AdvancedSorters',
Plug 'vim-ruby/vim-ruby'

call plug#end()
" }}}
