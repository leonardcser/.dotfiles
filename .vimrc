" auto-bootstrap plugins
if empty(glob('~/.vim/pack/plugins/start/vim-fugitive'))
  silent !git clone --depth 1 https://github.com/tpope/vim-fugitive.git
    \ ~/.vim/pack/plugins/start/vim-fugitive
endif
if empty(glob('~/.vim/pack/plugins/start/fzf.vim'))
  silent !git clone --depth 1 https://github.com/junegunn/fzf.vim.git
    \ ~/.vim/pack/plugins/start/fzf.vim
endif

syntax on
set termguicolors
set background=dark
colorscheme nord

" line numbers
set relativenumber
set number

" tabs & indentation
set tabstop=4
set softtabstop=2
set shiftwidth=4
set expandtab
set autoindent
set smartindent
set colorcolumn=80

" search
set hlsearch
set incsearch
set ignorecase
set smartcase

" line wrapping
set nowrap

" cursor line
set cursorline
set guicursor=

" mouse
set mouse=

" history & session
set undofile
set autoread

" appearance
set signcolumn=yes
set scrolloff=8
set sidescrolloff=10
set noshowmode
set fileformats=unix
set showtabline=0

" backspace
set backspace=indent,eol,start

" clipboard
set clipboard=unnamed

" split windows
set splitright
set splitbelow

" swap & update
set noswapfile
set updatetime=200

" diff
set diffopt+=vertical,iwhite

" leader key
let mapleader = " "

" fzf
set rtp+=/opt/homebrew/opt/fzf
nnoremap <leader>ff :Files<CR>
nnoremap <leader>fg :GFiles<CR>
nnoremap <leader>fs :Rg<CR>
nnoremap <leader>fr :History<CR>
nnoremap <leader>fb :Buffers<CR>

" netrw (file explorer)
let g:netrw_liststyle = 3
let g:netrw_banner = 0
nnoremap <leader>ee :Explore .<CR>
nnoremap <leader>ef :let @/=expand('%:t') <bar> Explore <bar> normal n<CR>

" git (fugitive)
nnoremap <leader>gs :tab Git<CR>
nnoremap <leader>gl :Git log --oneline -20<CR>
nnoremap <leader>gp :Git push origin<CR>
nnoremap <leader>gP :Git pull --rebase --prune<CR>
nnoremap <leader>ga :Git add -u<CR>
nnoremap <leader>gf :Git push --force-with-lease<CR>

" general keymaps
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz
nnoremap n nzzzv
nnoremap N Nzzzv
inoremap jk <ESC>
nnoremap <leader>nh :nohl<CR>

" window management
nnoremap <leader>sv <C-w>v
nnoremap <leader>sh <C-w>s
nnoremap <leader>se <C-w>=
nnoremap <leader>sx :close<CR>
nnoremap <C-k> <C-w>k
nnoremap <C-j> <C-w>j
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l

" make file executable
nnoremap <leader>ex :!chmod +x %<CR>
