set nocompatible

filetype plugin indent on
syntax on
set number
set autoindent

set expandtab
set softtabstop=2
set tabstop=2
set shiftwidth =2
set shiftround

set backspace  =indent,eol,start

if filereadable(expand("~/.vim/vim-plug/plug.vim"))
  so ~/.vim/vim-plug/plug.vim
  call plug#begin()
  Plug 'bling/vim-airline'
  Plug 'tpope/vim-sensible'
  Plug 'isobit/vim-caddyfile'

  Plug 'drewtempelmeyer/palenight.vim'
  Plug 'flazz/vim-colorschemes'
  call plug#end()

  "set background=dark
  "silent! colorscheme palenight
endif

