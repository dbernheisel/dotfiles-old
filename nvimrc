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
nnoremap <leader>vimrc :vsplit $MYVIMRC<CR>
nnoremap <leader>sv :source $MYVIMRC<CR>

" Preferences
set clipboard=unnamed       " allow yanks to go to system clipboard
set title                   " set iTerm2 tab title
set splitbelow              " open splits below current
set splitright              " open splits to the right of current
set laststatus=2

" Set lines and number gutter
set cursorline              " turn on row highlighting where cursor is
set cursorcolumn            " turn on column highlighting where cursor is
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
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

filetype off
call plug#begin('~/.config/nvim/plugged')

  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
    let g:deoplete#enable_at_startup = 1
    inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"
  Plug 'blueyed/vim-diminactive'      " Dim inactive buffers
  Plug 'tpope/vim-rails'              " :Eview, :Econtroller, :Emodel :A, :R
                                      " :Rgenerate, :Rails
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
  Plug 'terryma/vim-multiple-cursors' " visual, then C-n then i
  Plug 'simeji/winresizer'            " Resize panes with C-e and hjkl
  Plug 'vim-airline/vim-airline'      " Statusline
  Plug 'edkolev/tmuxline.vim'         " Statusline to tmux
  Plug 'tmux-plugins/vim-tmux-focus-events' " fix FocusGained and FocusLost
  Plug 'danilo-augusto/vim-afterglow' " Theme
  Plug 'tommcdo/vim-lion'             " Align with gl or gL
  Plug 'c-brenn/phoenix.vim'          " :Pgenerate, :Pserver, :Ppreview, Jump
  Plug 'tpope/vim-projectionist'      " required for some navigation features
  Plug 'slashmili/alchemist.vim'      " IEx, Docs, Jump, Mix, deoplete
  Plug 'elixir-lang/vim-elixir'       " Elixir support
  Plug 'christoomey/vim-tmux-navigator' " Navigate between VIM and TMUX seamlessly
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
filetype on

" Theming
set background=dark
if (&t_Co > 2 || has("gui_running")) && !exists("syntax_on")
  syntax on
endif

colorscheme afterglow

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
nmap <C-B> :NERDTreeToggle<CR>
let NERDTreeShowLineNumbers=0

" NERDCommenter
" For whatever reason, _ is actually /
map <C-_> <leader>c<space>

" FZF and ripgrep
command! -bang -nargs=* RipGrep call fzf#vim#grep('rg --column --line-number --no-heading --fixed-strings --ignore-case --no-ignore --hidden --follow --glob "!.git/**/*" --glob "!node_modules/**/*" --glob "!_build/**/*" --glob "!bower_components/**/*" --glob "!tmp/**/*" --glob "!coverage/**/*" --glob "!deps/**/*" --glob "!.hg/**/*" --glob "!.svn/**/*" --glob "!.sass-cache/**/*" --glob "!*.cache" --color "always" '.shellescape(<q-args>), 1, <bang>0)

" vim-fzf
nnoremap <C-P> :Files<CR>
nnoremap <C-F> :RipGrep<Space>

" vim-airline
"let g:airline_section_a       (mode, crypt, paste, spell, iminsert)
"let g:airline_section_b       (hunks, branch)
"let g:airline_section_c       (bufferline or filename)
"let g:airline_section_gutter  (readonly, csv)
"let g:airline_section_x       (tagbar, filetype, virtualenv)
"let g:airline_section_y       (fileencoding, fileformat)
"let g:airline_section_z       (percentage, line number, column number)
"let g:airline_section_error   (ycm_error_count, syntastic, eclim)
"let g:airline_section_warning (ycm_warning_count, whitespace)
let g:airline_left_sep = ''
let g:airline_right_sep = ''
let g:airline_section_b = ''
let g:airline_section_x = ''
let g:airline_section_y = '%y'
let g:airline_section_z = '%l/%L'
let g:airline#extensions#default#section_truncate_width = { 'b': 10 }

" vim-test
let test#strategy = "tslime"
let g:tslime_always_current_session = 1
let g:tslime_always_current_window = 1
"let test#ruby#rspec#options = '--require ~/.config/nvim/ruby_quickfix_formatter.rb --format QuickfixFormatter'
nmap <silent> <leader>t :TcstNearest<CR>
nmap <silent> <leader>T :TestFile<CR>
nmap <silent> <leader>a :TestSuite<CR>
nmap <silent> <leader>l :TestLast<CR>
nmap <silent> <leader>g :TestVisit<CR>

