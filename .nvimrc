" ln -s ~/dotfiles/.nvimrc ~/.config/nvim/init.vim

set mouse="" " Disable mouse

" Configure tabs to 2, and convert to spaces
set tabstop=2
set softtabstop=2
set expandtab
set shiftwidth=2

set showcmd

" Open to last line after close
autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif

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
nnoremap <C-H> <C-W><C-H>
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>

" Resize panes when window resizes
autocmd VimResized * :wincmd =

" Get off my lawn
nnoremap <Left> :echoe "Use h"<CR>
nnoremap <Right> :echoe "Use l"<CR>
nnoremap <Up> :echoe "Use k"<CR>
nnoremap <Down> :echoe "Use j"<CR>

" Make semicolon the same as colon
map ; :

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

" Set number gutter
set number                              " turn on number gutter
set relativenumber                      " turn on relative numbering to line

" Set absolute numbers when focus lost
autocmd FocusLost * :set number
autocmd FocusGained * :set relativenumber

" Set relative numbers only in Normal Mode
autocmd InsertEnter * :set number
autocmd InsertLeave * :set relativenumber

" Switch between the last two files
nnoremap <leader><leader> <c-^>

" install vim-plug if needed.
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.config/nvim/plugged')

  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
    let g:deoplete#enable_at_startup = 1
    inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"
  Plug 'blueyed/vim-diminactive'      " Dim inactive buffers
  Plug 'tpope/vim-rails'              " :Eview, :Econtroller, :Emodel :A, :R
                                      " :Rgenerate, :Rails
  Plug 'francoiscabrol/ranger.vim'    " File explorer
  Plug 'rbgrouleff/bclose.vim'        " Ranger dependency
  Plug 'scrooloose/nerdtree'          " Sidebar file explorer
  Plug 'tpope/vim-rake'               " Add :Rake commands
  Plug 'tpope/vim-bundler'            " Add :Bundle commands
  Plug 'janko-m/vim-test'             " Add :Test commands
  Plug 'airblade/vim-gitgutter'       " Git gutter
  Plug 'tpope/vim-fugitive'           " Git support. Works w/ Airline
  Plug 'sheerun/vim-polyglot'         " Languages support.
  Plug 'tpope/vim-eunuch'             " Add Bash commands Remove,Move,Find,etc
  Plug 'terryma/vim-multiple-cursors' " visual, then C-n then i
  Plug 'simeji/winresizer'            " Resize panes with C-e and hjkl
  Plug 'vim-airline/vim-airline'      " Statusline
  Plug 'danilo-augusto/vim-afterglow' " Theme
  Plug 'tommcdo/vim-lion'             " Align with gl or gL
  Plug 'c-brenn/phoenix.vim'          " :Pgenerate, :Pserver, :Ppreview, Jump
  Plug 'tpope/vim-projectionist'      " required for some navigation features
  Plug 'slashmili/alchemist.vim'      " IEx, Docs, Jump, Mix, deoplete
  Plug 'tpope/vim-endwise'            " Auto-close if, do, def
  Plug 'tpope/vim-surround'           " Add 's' command to give motions context
                                      " eg: `cs"'` will change the surrounding
                                      " double-quotes to single-quotes.
  Plug '/usr/local/opt/fzf'           " Use brew-installed fzf
  Plug 'junegunn/fzf.vim'             " Fuzzy-finder
  Plug 'ludovicchabant/vim-gutentags' " Ctags support.
    let g:gutentags_cache_dir = '~/.ctags_cache'

  Plug 'neomake/neomake'              " Execute linters and compilers
  Plug 'jaawerth/neomake-local-eslint-first'  " Prefer local eslint to global eslint
  " Run after write
  augroup localneomake
    autocmd! BufWritePost * Neomake
  augroup END

  " Don't tell me to use smartquotes in markdown ok?
  let g:neomake_markdown_enabled_makers = []

  " Turn off jshint (rely on eslint)
  let g:neomake_javascript_enabled_makers = ['eslint']
  " Configure a nice credo setup, courtesy https://github.com/neomake/neomake/pull/300
"  let g:neomake_elixir_enabled_makers = ['mycredo']
"  function! NeomakeCredoErrorType(entry)
"    if a:entry.type ==# 'F'      " Refactoring opportunities
"      let l:type = 'W'
"    elseif a:entry.type ==# 'D'  " Software design suggestions
"      let l:type = 'I'
"    elseif a:entry.type ==# 'W'  " Warnings
"      let l:type = 'W'
"    elseif a:entry.type ==# 'R'  " Readability suggestions
"      let l:type = 'I'
"    elseif a:entry.type ==# 'C'  " Convention violation
"      let l:type = 'W'
"    else
"      let l:type = 'M'           " Everything else is a message
"    endif
"    let a:entry.type = l:type
"  endfunction
"
"  let g:neomake_elixir_mycredo_maker = {
"    \ 'exe': 'mix',
"    \ 'args': ['credo', 'list', '%:p', '--format=oneline'],
"    \ 'errorformat': '[%t] %. %f:%l:%c %m,[%t] %. %f:%l %m',
"    \ 'postprocess': function('NeomakeCredoErrorType')
"    \ }
"
call plug#end()

" Theming
set background=dark
syntax enable
colorscheme afterglow
au BufNewFile,BufRead Brewfile setf ruby

" Highlight 81st character
highlight ColorColumn ctermbg=darkred
call matchadd('ColorColumn', '\%81v', 100) " alert at 81st vertical char

" FZF and RipGrep
if executable('fzf')
  set rtp+=/usr/local/opt/fzf " use homebrew-installed fzf
  set grepprg=rg\ --vimgrep   " use ripgrep
endif

" vim-diminactive change background color
highlight ColorColumn ctermbg=0 guibg=#eeeeee

" start vim-ranger on opening a directory
if executable('ranger')
  let g:loaded_netrw       = 1
  let g:loaded_netrwPlugin = 1
  if argc() == 1 && argv(0) == '.'
    autocmd VimEnter * Ranger
  endif
endif

" Local config
if filereadable($HOME . '/.vimrc.local')
  source ~/.vimrc.local
endif

" NERDTree
nmap <C-B> :NERDTreeToggle<CR>
let NERDTreeShowLineNumbers=0

" FZF and ripgrep
command! -bang -nargs=* RipGrep call fzf#vim#grep('rg --column --line-number --no-heading --fixed-strings --ignore-case --no-ignore --hidden --follow --glob "!.git/**/*" --glob "!node_modules/**/*" --glob "!bower_components/**/*" --glob "!tmp/**/*" --glob "!coverage/**/*" --glob "!deps/**/*" --glob "!.hg/**/*" --glob "!.svn/**/*" --glob "!.sass-cache/**/*" --glob "!*.cache" --color "always" '.shellescape(<q-args>), 1, <bang>0)

" vim-fzf
nnoremap <C-P> :Files<CR>
nnoremap <C-F> :RipGrep<Space>

" vim-test commands
nmap <silent> <leader>t :TestNearest<CR>
nmap <silent> <leader>T :TestFile<CR>
nmap <silent> <leader>a :TestSuite<CR>
nmap <silent> <leader>l :TestLast<CR>
nmap <silent> <leader>g :TestVisit<CR>

