" ln -s ~/dotfiles/.nvimrc ~/.config/nvim/init.vim
set nocompatible

set mouse="" " Disable mouse

" Configure tabs to 2, and convert to spaces
set tabstop=2
set backspace=2
set softtabstop=2
set expandtab
set shiftwidth=2

set showcmd

" Backups
set nobackup
set nowritebackup
set noswapfile

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

set autowrite   " Automatically :write before running commands

" Map keys for moving between splits
nnoremap <C-H> <C-W><C-H>
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>

" Get off my lawn
nnoremap <Left> :echoe "Use h"<CR>
nnoremap <Right> :echoe "Use l"<CR>
nnoremap <Up> :echoe "Use k"<CR>
nnoremap <Down> :echoe "Use j"<CR>

" Make semicolon the same as colon
map ; :

" jj maps to Esc while in insert mode
inoremap jj <Esc>

" leader to edit vimrc and reload
if !exists("*ResetConfig")
  function! ResetConfig()
    set all&
    source $MYVIMRC
  endfunction
endif

nnoremap <leader>ev :vsplit $MYVIMRC<CR>
nnoremap <leader>sv :call ResetConfig()<CR>

" Preferences
set clipboard=unnamed       " allow yanks to go to system clipboard
set title                   " set iTerm2 tab title
set splitbelow              " open splits below current
set splitright              " open splits to the right of current
set laststatus=2

" Set lines and number gutter
set cursorline              " turn on row highlighting where cursor is
set ruler                   " turn on ruler information in statusline

" Set number gutter
set number                              " turn on number gutter
set relativenumber                      " turn on relative numbering to line
function! NumberToggle()
  if(&relativenumber == 1)
    set norelativenumber
  else
    set relativenumber
  endif
endfun
nnoremap <leader><C-L> :call NumberToggle()<CR>

" Switch between the last two files
nnoremap <leader><leader> <c-^>

" install vim-plug if needed.
if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

filetype off
call plug#begin('~/.config/nvim/plugged')

  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
    let g:deoplete#enable_at_startup = 1
    inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"

  Plug 'xolox/vim-notes'              " :Notes
  Plug 'xolox/vim-misc'               " i dunno.. just need it for vim-notes
  Plug 'tpope/vim-rails'              " :Eview, :Econtroller, :Emodel, :R
                                      " :Rgenerate, :Rails
  Plug 'tpope/vim-projectionist'      " :A, :AS, :AV, and :AT
  Plug 'andyl/vim-projectionist-elixir' " Projectionist support for Elixir
  Plug 'francoiscabrol/ranger.vim', { 'on': 'Ranger' }    " File explorer
  Plug 'rbgrouleff/bclose.vim'        " Ranger dependency
  Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' } " Sidebar file explorer
  Plug 'scrooloose/nerdcommenter'     " Easier block commenting.
  Plug 'tpope/vim-rake'               " Add :Rake commands
  Plug 'tpope/vim-bundler'            " Add :Bundle commands
  Plug 'janko-m/vim-test'             " Add :Test commands
  Plug 'jgdavey/tslime.vim'           " Add tslime test strategy for vim-test
  Plug 'jgdavey/vim-turbux'           " vim-test to tmux
  Plug 'skywind3000/asyncrun.vim'     " Add asyncrun test strategy for vim-test
  Plug 'airblade/vim-gitgutter'       " Git gutter
  Plug 'tpope/vim-fugitive'           " Git support. Works w/ Airline
  Plug 'christoomey/vim-conflicted'   " Git merge conflict support
  Plug 'sheerun/vim-polyglot'         " Languages support.
  Plug 'tpope/vim-eunuch'             " Add Bash commands Remove,Move,Find,etc
  Plug 'pbrisbin/vim-mkdir'           " create directories if they don't exist
  Plug 'terryma/vim-multiple-cursors' " visual, then C-n then I
  Plug 'simeji/winresizer'            " Resize panes with C-e and hjkl
  Plug 'vim-airline/vim-airline'      " Statusline
  Plug 'edkolev/tmuxline.vim'         " Statusline to tmux
  Plug 'danilo-augusto/vim-afterglow' " Theme
  Plug 'reewr/vim-monokai-phoenix'    " Theme
  Plug 'tommcdo/vim-lion'             " Align with gl or gL
  Plug 'c-brenn/phoenix.vim'          " :Pgenerate, :Pserver, :Ppreview, Jump
  Plug 'slashmili/alchemist.vim'      " IEx, Docs, Jump, Mix, deoplete
  Plug 'powerman/vim-plugin-AnsiEsc'  " This fixes some docs
  Plug 'tmux-plugins/vim-tmux'        " tmux.conf support
  Plug 'christoomey/vim-tmux-navigator' " Navigate between VIM and TMUX seamlessly
  Plug 'tmux-plugins/vim-tmux-focus-events' " fix FocusGained and FocusLost
  Plug 'tpope/vim-endwise'            " Auto-close if, do, def
  Plug 'tpope/vim-surround'           " Add 's' command to give motions context
                                      " eg: `cs"'` will change the surrounding
                                      " double-quotes to single-quotes.
  Plug '/usr/local/opt/fzf'           " Use brew-installed fzf
  Plug 'junegunn/fzf.vim'             " Fuzzy-finder
  Plug 'dkprice/vim-easygrep'         " Grep across files
  Plug 'ludovicchabant/vim-gutentags' " Ctags support.
    let g:gutentags_cache_dir = '~/.ctags_cache'

  Plug 'neomake/neomake'              " Execute linters and compilers
  " Run after write
  augroup localneomake
    autocmd! BufWritePost * Neomake
  augroup END

  " Don't tell me to use smartquotes in markdown ok?
  let g:neomake_markdown_enabled_makers = []

  " Turn off jshint (rely on eslint)
  let g:neomake_javascript_enabled_makers = ['eslint']
  let g:neomake_javascript_eslint_exe = system('PATH=$(npm bin):$PATH && which eslint | tr -d "\n"')

  " Turn on credo checking
  let g:neomake_elixir_enabled_makers = ['mix', 'credo']
call plug#end()
filetype on

" Theming
set background=dark
set termguicolors
syntax on

colorscheme monokai-phoenix

augroup vimrcEx
  autocmd!

  " Open to last line after close
  autocmd BufReadPost *
    \ if &ft != 'gitcommit' && line("'\"") > 1 && line("'\"") <= line("$") |
    \ exe "normal! g`\"" |
    \ endif

  " Set syntax highlighting
  autocmd BufNewFile,BufRead Brewfile setf ruby
  autocmd BufNewFile,BufRead *.md setf markdown
  autocmd BufNewFile,BufRead *.es6 setf javascript
  autocmd BufNewFile,BufRead *.ex* setf elixir

  " Enable spellchecking for Markdown
  autocmd FileType markdown setlocal spell

  " Wrap at 80 characters for Markdown
  autocmd BufNewFile,BufRead *.md setlocal textwidth=80

  " Allow stylesheets to autocomplete hyphenated words
  autocmd FileType css,scss,sass setlocal iskeyword+=-

  " Remove trailing whitespace on save
  autocmd BufWritePre * :%s/\s\+$//e

  " Set absolute numbers when focus lost
  autocmd FocusLost * :set norelativenumber
  autocmd FocusGained * :set relativenumber

  " Set relative numbers only in Normal Mode
  autocmd InsertEnter * :set number
  autocmd InsertLeave * :set relativenumber

  " Resize panes when window resizes
  autocmd VimResized * :wincmd =
augroup END

" Highlight 81st character
highlight OverLength ctermbg=red ctermfg=white guibg=#600000
function! UpdateMatch()
  if &previewwindow || &ft !~ '^\%(qf\)$'
    match none
  elseif &ft !~ '^\%(elixir\)$'
    match OverLength /\%81v/
  else
    match OverLength /\%101v/
  endif
endfun
autocmd BufEnter,BufWinEnter * call UpdateMatch()

" FZF and RipGrep
if executable('fzf')
  set rtp+=/usr/local/opt/fzf " use homebrew-installed fzf
  set grepprg=rg\ --vimgrep   " use ripgrep
endif

" start vim-ranger on opening a directory
"if executable('ranger')
  "let g:loaded_netrw       = 1
  "let g:loaded_netrwPlugin = 1
  "let g:ranger_map_keys    = 0 " disable <C-f> mapping
  "if argc() == 1 && argv(0) == '.'
    "autocmd VimEnter * Ranger
  "endif
"endif

" Local config
if filereadable($HOME . '/.vimrc.local')
  source ~/.vimrc.local
endif

" NERDTree
nmap <leader>b :NERDTreeToggle<CR>
let NERDTreeShowLineNumbers=0

" NERDCommenter
" For whatever reason, _ is actually /
map <C-_> <leader>c<space>

" FZF and ripgrep
command! -bang -nargs=* RipGrep call fzf#vim#grep('rg --column --line-number --no-heading --fixed-strings --ignore-case --no-ignore --hidden --follow --glob "!.git/**/*" --glob "!node_modules/**/*" --glob "!_build/**/*" --glob "!priv/static/**/*" --glob "!bower_components/**/*" --glob "!tmp/**/*" --glob "!coverage/**/*" --glob "!deps/**/*" --glob "!.hg/**/*" --glob "!.svn/**/*" --glob "!.sass-cache/**/*" --glob "!*.cache" --color "always" '.shellescape(<q-args>), 1, <bang>0)

" vim-fzf
nnoremap <C-P> :Files<CR>
nnoremap <leader>f :RipGrep<Space>

" vim-airline
let g:airline_left_sep = ''
let g:airline_right_sep = ''
let g:airline_section_b = ''
let g:airline_section_x = ''
let g:airline_section_y = '%y'
let g:airline_section_z = '%l/%L'
let g:airline#extensions#tmuxline#enabled = 0
let g:airline#extensions#default#section_truncate_width = { 'b': 10 }

" vim-tmuxline
let g:tmuxline_preset = {
  \'a'    : '#h',
  \'b'    : '#S',
  \'c'    : '',
  \'win'  : '#I #W',
  \'cwin' : '#I #W',
  \'x'    : '#(git rev-parse --abbrev-ref HEAD)',
  \'y'    : ['%Y-%m-%d %a', '%H:%M'],
  \'z'    : '#(pmset -g batt | egrep "([0-9]+\%).*" -o | cut -f1 -d ";")'}

" vim-alchemist
let g:alchemist_tag_map = 'gd'

" vim-notes
let g:notes_directories = ['~/Documents/Notes']
let g:notes_smart_quotes = 0


" vim-test
function! RunTestSuite()
  if filereadable("bin/test_suite")
    Tmux clear; echo "bin/test_suite"; bin/test_suite
  else
    TestSuite
  endif
endfunction

let test#strategy = "tslime"
let g:tslime_always_current_session = 1
let g:tslime_always_current_window = 1
nmap <silent> <leader>t :TestNearest<CR>
nmap <silent> <leader>T :TestFile<CR>
nmap <silent> <leader>a :call RunTestSuite()<CR>
nmap <silent> <leader>l :TestLast<CR>
nmap <silent> <leader>g :TestVisit<CR>



