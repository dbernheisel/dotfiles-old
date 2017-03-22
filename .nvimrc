set mouse="" " Disable mouse clicks

" Configure tabs to 2, and convert to spaces
set tabstop=2
set softtabstop=2
set expandtab
set shiftwidth=2

" Turn on rendering whitespace
set listchars+=trail:·,precedes:←,extends:→,tab:¬\ ,nbsp:+,conceal:※
set list

" Turn on undo file so I can undo even after closing a file
silent !mkdir -p ~/.vim/undo > /dev/null 2>&1
set undofile
set undodir=~/.vim/undo

" Set map key to space
let mapleader=' '
let g:maplocalleader='\\'

set encoding=utf-8

" Set searching to highlighting, incrementally, and smartcase search
set hlsearch
set incsearch
set ignorecase
set smartcase
map <silent> <CR> :nohl<CR>

autocmd BufWritePre * :%s/\s\+$//e " Remove trailing whitespace on save
set autowrite   " Automatically :write before running commands

" Map keys for moving between splits
nnoremap <C-H> <C-W><Left>
nnoremap <C-J> <C-W><Down>
nnoremap <C-K> <C-W><Up>
nnoremap <C-L> <C-W><Right>

" Resize panes when window resizes
autocmd VimResized * :wincmd =

" Get off my lawn
nnoremap <Left> :echoe "Use h"<CR>
nnoremap <Right> :echoe "Use l"<CR>
nnoremap <Up> :echoe "Use k"<CR>
nnoremap <Down> :echoe "Use j"<CR>

" Make semicolon the same as colon
nnoremap : :
nnoremap ; :

" vim-fzf
nnoremap <C-P> :Files<CR>
nnoremap <C-F> :Find<CR>

" vim-test commands
nmap <silent> <leader>t :TestNearest<CR>
nmap <silent> <leader>T :TestFile<CR>
nmap <silent> <leader>a :TestSuite<CR>
nmap <silent> <leader>l :TestLast<CR>
nmap <silent> <leader>g :TestVisit<CR>

" Preferences
set clipboard=unnamed       " allow yanks to go to system clipboard
set title                   " set iTerm2 tab title
set splitbelow              " open splits below current
set splitright              " open splits to the right of current
set noswapfile              " Don't need no stinkin SWAP!

" Set lines and number gutter
set cursorline              " turn on row highlighting where cursor is
set cursorcolumn            " turn on column highlighting where cursor is
set ruler                   " turn on ruler information in statusline
set number                  " turn on number gutter

" Switch between the last two files
nnoremap <leader><leader> <c-^>

" FZF and ripgrep
if executable("rg")
  command! -bang -nargs=* Find call fzf#vim#grep('rg --column --line-number --no-heading --fixed-strings --ignore-case --no-ignore --hidden --follow --glob "!.git/*|!.hg|!.svn|!.sass-cache|!node_modules|!bower_components|!_build|!tmp|!coverage|!deps" --color "always" '.shellescape(<q-args>), 1, <bang>0)
endif

call plug#begin('~/.config/nvim/plugged')

  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
    let g:deoplete#enable_at_startup = 1
    inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"

  Plug 'tpope/vim-rails'
  Plug 'tpope/vim-rake'
  Plug 'tpope/vim-bundler'
  Plug 'janko-m/vim-test'
  Plug 'airblade/vim-gitgutter'
  Plug 'tpope/vim-fugitive'
  Plug 'sheerun/vim-polyglot'
  Plug 'tpope/vim-eunuch'
  Plug 'terryma/vim-multiple-cursors'
  Plug 'simeji/winresizer'
  Plug 'vim-airline/vim-airline'
  Plug 'danilo-augusto/vim-afterglow'

  Plug 'c-brenn/phoenix.vim'
  "Plug 'tpope/vim-projectionist' " required for some navigation features
  Plug 'slashmili/alchemist.vim' " Elixir plugin
  Plug 'pangloss/vim-javascript'          " JSX-compatible JS
  Plug 'mxw/vim-jsx'                      " JSX syntax
  Plug 'kchmck/vim-coffee-script'
  Plug 'tpope/vim-endwise'
  Plug 'tpope/vim-surround'
  Plug 'junegunn/fzf.vim'
  Plug 'ludovicchabant/vim-gutentags'
    let g:gutentags_cache_dir = '~/.ctags_cache'

  Plug 'neomake/neomake'
  augroup localneomake
    autocmd! BufWritePost * Neomake
  augroup END

  " Don't tell me to use smartquotes in markdown ok?
  let g:neomake_markdown_enabled_makers = []

  " Configure a nice credo setup, courtesy https://github.com/neomake/neomake/pull/300
  let g:neomake_elixir_enabled_makers = ['mycredo']
  function! NeomakeCredoErrorType(entry)
    if a:entry.type ==# 'F'      " Refactoring opportunities
      let l:type = 'W'
    elseif a:entry.type ==# 'D'  " Software design suggestions
      let l:type = 'I'
    elseif a:entry.type ==# 'W'  " Warnings
      let l:type = 'W'
    elseif a:entry.type ==# 'R'  " Readability suggestions
      let l:type = 'I'
    elseif a:entry.type ==# 'C'  " Convention violation
      let l:type = 'W'
    else
      let l:type = 'M'           " Everything else is a message
    endif
    let a:entry.type = l:type
  endfunction

  let g:neomake_elixir_mycredo_maker = {
    \ 'exe': 'mix',
    \ 'args': ['credo', 'list', '%:p', '--format=oneline'],
    \ 'errorformat': '[%t] %. %f:%l:%c %m,[%t] %. %f:%l %m',
    \ 'postprocess': function('NeomakeCredoErrorType')
    \ }

call plug#end()

" Theming
set background=dark
syntax enable
colorscheme afterglow

" Highlight 81st character
highlight ColorColumn ctermbg=darkred
call matchadd('ColorColumn', '\%81v', 100) " alert at 81st vertical char

" FZF and RipGrep
if executable('/usr/local/opt/fzf')
  set rtp+=/usr/local/opt/fzf " use homebrew-installed fzf
  set grepprg=rg\ --vimgrep   " use ripgrep
endif

" Local config
if filereadable($HOME . '/.vimrc.local')
  source ~/.vimrc.local
endif
