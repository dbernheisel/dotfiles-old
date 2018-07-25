" ln -s ~/dotfiles/.nvimrc ~/.config/nvim/init.vim

" General
set nocompatible
set clipboard=unnamed       " allow yanks to go to system clipboard
set title                   " set tab title
set splitbelow              " open splits below current
set splitright              " open splits to the right of current
set laststatus=2
set encoding=utf-8
set mouse=""                " Disable mouse

" Configure tabs to 2, and convert to spaces
set tabstop=2
set backspace=2
set softtabstop=2
set expandtab
set shiftwidth=2

" Show the in-process keys for a command
set showcmd

" Backups
set nobackup
set nowritebackup
set noswapfile

" Turn off linewise up and down movements
nmap j gj
nmap k gk

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

" Set searching to highlighting, incrementally, and smartcase search
set hlsearch
set incsearch
set ignorecase
set smartcase
map <silent> <CR> :nohl<CR>

" Automatically :write before running commands
set autowrite

" Map keys for moving between splits
nnoremap <C-H> <C-W><C-H>
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>

" Get off my lawn
nnoremap <Left> :WinResizerStartResize<CR><Char-104><CR>
nnoremap <Right> :WinResizerStartResize<CR><Char-108><CR>
nnoremap <Up> :WinResizerStartResize<CR><Char-107><CR>
nnoremap <Down> :WinResizerStartResize<CR><Char-106><CR>
imap <Up> <nop>
imap <Down> <nop>
imap <Left> <nop>
imap <Right> <nop>

" Make semicolon the same as colon
map ; :

" jj maps to Esc while in insert mode
inoremap jj <Esc>

" Shortcuts for editing vimrc. I do it too much
nnoremap <leader>ev :vsplit $MYVIMRC<CR>
nnoremap <leader>sv :source $MYVIMRC<CR>

" Set lines and number gutter
set cursorline " turn on row highlighting where cursor is
set ruler      " turn on ruler information in statusline

" Set number gutter
set number
function! NumberToggle()
  if(&relativenumber == 1)
    set norelativenumber
  else
    set relativenumber
  endif
  echo "Toggled relative numbering"
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

  Plug 'wellle/tmux-complete.vim'     " Deoplete autocompletion for tmux session text
  Plug 'rizzatti/dash.vim', { 'on': 'Dash' } " :Dash

  Plug 'tpope/vim-projectionist'      " :A, :AS, :AV, and :AT
  Plug 'andyl/vim-projectionist-elixir', { 'for': 'elixir' } " Projectionist support for Elixir
  Plug 'tpope/vim-rails', { 'for': 'ruby' } " Projectionist support for Ruby

  Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' } " Sidebar file explorer
  nmap <leader>b :call ToggleFileTree()<CR>
  let NERDTreeShowLineNumbers=0
  " Don't fuck up the icons on reloading this file
  function! ToggleFileTree()
    if exists("g:loaded_webdevicons")
      if exists("g:NERDTree")
        call webdevicons#refresh()
      endif
    endif
    :NERDTreeToggle
  endfun

  Plug 'scrooloose/nerdcommenter'     " Easier block commenting.
  nmap <leader>/ <leader>c<space>
  vmap <leader>/ <leader>c<space>

  " Add :Test commands
  Plug 'jgdavey/tslime.vim'  " Add tslime test strategy for vim-test
  Plug 'jgdavey/vim-turbux'  " vim-test to tmux
  Plug 'janko-m/vim-test', { 'on': ['TestNearest', 'TestFile', 'TestSuite', 'TestLast', 'TestVisit'] }
  let g:turbux_command_prefix = 'bundle exec'
  let g:tslime_always_current_session = 1
  let g:tslime_always_current_window = 1
  let g:test#strategy = "tslime"
  function! RunTestSuite()
    if filereadable('bin/test_suite')
      Tmux clear; echo 'bin/test_suite'; bin/test_suite
    elseif filereadable("bin/test")
      Tmux clear; echo 'bin/test'; bin/test
    else
      TestSuite
    endif
  endfunction
  nmap <silent> <leader>t :TestNearest<CR>
  nmap <silent> <leader>T :TestFile<CR>
  nmap <silent> <leader>a :call RunTestSuite()<CR>
  nmap <silent> <leader>l :TestLast<CR>
  nmap <silent> <leader>g :TestVisit<CR>

  Plug 'airblade/vim-gitgutter'       " Git gutter
  Plug 'tpope/vim-fugitive'           " Git support. Works w/ Airline
  Plug 'christoomey/vim-conflicted'   " Git merge conflict support
  Plug 'sheerun/vim-polyglot'         " Languages support.
  let g:elm_format_autosave = 1
  Plug 'mhinz/vim-mix-format', { 'for': 'elixir' } " Elixir formatting
  let g:mix_format_on_save = 0
  Plug 'tpope/vim-eunuch'             " Add Bash commands Remove,Move,Find,etc
  Plug 'pbrisbin/vim-mkdir'           " create directories if they don't exist
  Plug 'terryma/vim-multiple-cursors' " visual, then C-n then I
  Plug 'simeji/winresizer'            " Resize panes with C-e and hjkl
  Plug 'itchyny/lightline.vim'        " Statusline
  let g:lightline = {
    \ 'colorscheme': 'wombat',
    \ }
  set noshowmode
  "Plug 'edkolev/tmuxline.vim'         " Statusline to tmux
  let g:tmuxline_preset = {
    \'a'    : '#h',
    \'b'    : '#S',
    \'c'    : '',
    \'win'  : '#I #W',
    \'cwin' : '#I #W',
    \'x'    : '#(git rev-parse --abbrev-ref HEAD)',
    \'y'    : ['%Y-%m-%d %a', '%H:%M'],
    \'z'    : '#(pmset -g batt | egrep "([0-9]+\%).*" -o | cut -f1 -d ";")'}

  Plug 'reedes/vim-colors-pencil'     " Theme for markdown editing
  Plug 'crater2150/vim-theme-chroma'  " Theme - Light
  Plug 'Erichain/vim-monokai-pro'     " Theme - Dark
  Plug 'reewr/vim-monokai-phoenix'    " Theme - Darker

  " Distraction-free writing mode
  Plug 'reedes/vim-pencil', { 'for': 'markdown' }            " Soft breaks
  Plug 'junegunn/limelight.vim', { 'for': 'markdown' }       " Focus mode
  Plug 'junegunn/goyo.vim', { 'for': 'markdown' }            " ProseMode for writing Markdown
  Plug 'reedes/vim-wordy', { 'for': 'markdown' }             " Weak language checker
  let g:pencil#textwidth = 72
  let g:goyo_width = 72
  function! s:goyo_enter()
    " light theme
    setlocal background=light
    colorscheme pencil

    " turn off cursor-line-highlight auto-indent, whitespace, and in-progress
    " commands
    setlocal noai nolist noshowcmd nocursorline

    " turn on autocorrect
    setlocal spell complete+=s

    Limelight  " Focus on the current paragraph, dim the others
    SoftPencil " Turn on soft breaks
    Wordy weak " Highlight weak words
  endfunction
  function! s:goyo_leave()
    setlocal cursorline
    setlocal showcmd list ai
    setlocal nospell complete-=s
    setlocal background=dark
    colorscheme monokai-phoenix
    Limelight!
    NoPencil
    NoWordy
  endfunction
  autocmd! User GoyoEnter nested call <SID>goyo_enter()
  autocmd! User GoyoLeave nested call <SID>goyo_leave()
  nmap <leader>df :Goyo<CR>

  Plug 'tommcdo/vim-lion'             " Align with gl or gL

  Plug 'slashmili/alchemist.vim'      " IEx, Docs, Jump, Mix, deoplete
  let g:alchemist_tag_disable = 1

  Plug 'powerman/vim-plugin-AnsiEsc'  " This fixes some docs
  Plug 'tmux-plugins/vim-tmux'        " tmux.conf support
  Plug 'tmux-plugins/vim-tmux-focus-events' " fix FocusGained and FocusLost
  Plug 'tpope/vim-endwise'            " Auto-close if, do, def
  Plug 'tpope/vim-surround'           " Add 's' command to give motions context
                                      " eg: `cs"'` will change the surrounding
                                      " double-quotes to single-quotes.

  " FZF and RipGrep
  Plug '/usr/local/opt/fzf'           " Use brew-installed fzf
  Plug 'junegunn/fzf.vim'             " Fuzzy-finder
  nnoremap <C-P> :Files<CR>
  nnoremap <leader>f :RipGrep<Space>
  if executable('fzf')
    set rtp+=/usr/local/opt/fzf " use homebrew-installed fzf
    set grepprg=rg\ --vimgrep   " use ripgrep
    command! -bang -nargs=* RipGrep call fzf#vim#grep('rg --column --line-number --no-heading --fixed-strings --ignore-case --hidden --follow --glob "!.git/**/*" --glob "!.elixir_ls/**/*" --glob "!node_modules/**/*" --glob "!_build/**/*" --glob "!tags" --glob "!priv/static/**/*" --glob "!bower_components/**/*" --glob "!storage/**/*" --glob "!tmp/**/*" --glob "!coverage/**/*" --glob "!deps/**/*" --glob "!.hg/**/*" --glob "!.svn/**/*" --glob "!.sass-cache/**/*" --glob "!*.cache" --color "always" '.shellescape(<q-args>), 1, <bang>0)
  endif

  Plug 'dkprice/vim-easygrep'         " Grep across files
  Plug 'ludovicchabant/vim-gutentags' " Ctags support.

  Plug 'w0rp/ale'                     " Execute linters and compilers
  let g:ale_linters = {'javascript': ['eslint']}

  Plug 'ryanoasis/vim-devicons'       " :)
  Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
  augroup nerdtreedisablecursorline
    autocmd!
    autocmd FileType nerdtree setlocal nocursorline
  augroup end
call plug#end()
filetype on

" Theme
set background=dark
colorscheme monokai-phoenix
syntax on

if $TERM_PROGRAM == "iTerm.app" || $TERMINFO =~ "kitty\.app"
  " Turn on 24bit color
  set termguicolors
  let g:truecolor = 1

" Get italics working
  hi Comment gui=italic
else
  let g:truecolor = 0
endif

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
  autocmd BufNewFile,BufRead *.arb setf ruby

  " Enable spellchecking for Markdown
  autocmd FileType markdown setlocal nolist spell foldlevel=999 tw=0 nocin
  let g:vim_markdown_frontmatter = 1

  " Wrap at 72 characters for Markdown
  autocmd BufNewFile,BufRead *.md setlocal textwidth=72

  " Allow stylesheets to autocomplete hyphenated words
  autocmd FileType css,scss,sass setlocal iskeyword+=-

  " Remove trailing whitespace on save
  autocmd BufWritePre * :%s/\s\+$//e

  " Resize panes when window resizes
  autocmd VimResized * :wincmd =
augroup END

" Highlight character that marks where line is too long
highlight OverLength ctermbg=red ctermfg=white guibg=#600000
function! UpdateMatch()
  if &previewwindow || &ft !~ '^\%(qf\)$'
    match none
  elseif &ft =~ '^\%(elixir\)$'
    match OverLength /\%101v/
  elseif &ft =~ '^\%(markdown\)$'
    match OverLength /\%73v/
  else
    match OverLength /\%81v/
  endif
endfun
autocmd BufEnter,BufWinEnter * call UpdateMatch()

" Local config
if filereadable($HOME . '/.vimrc.local')
  source ~/.vimrc.local
endif
