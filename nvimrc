" ln -s ~/dotfiles/.nvimrc ~/.config/nvim/init.vim

" General
set nocompatible
set clipboard=unnamed       " allow yanks to go to system clipboard
set title                   " set tab title
set splitbelow              " open splits below current
set splitright              " open splits to the right of current
set laststatus=2
set encoding=utf-8

" Disable mouse
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

if $TERM_PROGRAM == "iTerm.app" || $TERMINFO =~ "kitty\.app"
  " Turn on 24bit color
  set termguicolors
  let g:truecolor = 1

" Get italics working
  hi Comment gui=italic
else
  let g:truecolor = 0
endif

" Automatically :write before running commands
set autowrite

" Map keys for moving between splits
nnoremap <C-H> <C-W><C-H>
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>

" Emulate tmux shortcuts
" Rembmer to use :tabclose instead of :q for zoomed terminals
nnoremap <C-A>z :-tabedit %<CR>
nnoremap <C-A>\ :vsplit term://$SHELL<CR>
nnoremap <C-A>- :split term://$SHELL<CR>

" Get off my lawn
imap <Up> <nop>
imap <Down> <nop>
imap <Left> <nop>
imap <Right> <nop>

" Terminal Mode mappings
tnoremap <C-O> <C-\><C-N>
tnoremap <A-H> <C-\><C-N><C-W>h
tnoremap <A-J> <C-\><C-N><C-W>j
tnoremap <A-K> <C-\><C-N><C-W>k
tnoremap <A-L> <C-\><C-N><C-W>l
inoremap <A-H> <C-\><C-N><C-W>h
inoremap <A-J> <C-\><C-N><C-W>j
inoremap <A-K> <C-\><C-N><C-W>k
inoremap <A-L> <C-\><C-N><C-W>l

" Make semicolon the same as colon
map ; :

" jj maps to Esc while in insert mode
inoremap jj <Esc>

" Shortcuts for editing vimrc. I do it too much
nnoremap <leader>ev :vsplit $MYVIMRC<CR>
nnoremap <leader>sv :source $MYVIMRC<CR>

" Set lines and number gutter
set nocursorline " turn off row highlighting where cursor is
set ruler        " turn on ruler information in statusline

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

  Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }
  nnoremap <silent> gd :call LanguageClient#textDocument_definition()<CR>

  let g:LanguageClient_autoStart = 1
  let g:LanguageClient_serverCommands = {}

  if executable('pyls')
    " pip install python-language-server
    let g:LanguageClient_serverCommands.python = ['pyls']
  endif

  if executable('language_server.sh')
    " git clone git@github.com:JakeBecker/elixir-ls.git ~/.elixir_ls
    " cd ~/.elixir_ls
    " mix deps.get && mix.compile
    " mix elixir_ls.release - .
    " add it to the $PATH
    let g:LanguageClient_serverCommands.elixir = ['language_server.sh']
  endif

  if executable('javascript-typescript-stdio')
    " yarn global add javascript-typescript-langserver   -or-
    " npm i -g javascript-typescript-langserver
    let g:LanguageClient_serverCommands['javascript'] = ['javascript-typescript-stdio']
    let g:LanguageClient_serverCommands['typescript'] = ['javascript-typescript-stdio']
    let g:LanguageClient_serverCommands['javascript.jsx'] = ['javascript-typescript-stdio']
  endif

  if executable('html-languageserver')
    " yarn global add vscode-html-languageserver-bin   -or-
    " npm i -g vscode-html-languageserver-bin
    let g:LanguageClient_serverCommands.html = ['html-languageserver', '--stdio']
  endif

  if executable('css-languageserver')
    " yarn global add vscode-css-languageserver-bin   -or-
    " npm i -g vscode-css-languageserver-bin
    let g:LanguageClient_serverCommands.css = ['css-languageserver', '--stdio']
    let g:LanguageClient_serverCommands.less = ['css-languageserver', '--stdio']
  endif

  if executable('json-languageserver')
    " yarn global add vscode-json-languageserver-bin   -or-
    " npm i -g vscode-json-languageserver-bin
    let g:LanguageClient_serverCommands.json = ['json-languageserver', '--stdio']
  endif

  if executable('ocaml-language-server')
    " yarn global add ocaml-language-server   -or-
    " npm i -g ocaml-language-server
    let g:LanguageClient_serverCommands.reason = ['ocaml-language-server', '--stdio']
    let g:LanguageClient_serverCommands.ocaml = ['ocaml-language-server', '--stdio']
  endif

  if executable('solargraph')
    " gem install solargraph
    let g:LanguageClient_serverCommands.ruby = ['solargraph', 'stdio']
  endif

  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
  let g:deoplete#enable_at_startup = 1
  inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"

  Plug 'w0rp/ale'                     " Execute linters and compilers
  let g:ale_linters = {'javascript': ['eslint']}

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

  Plug 'vimlab/split-term.vim'        " :VTerm, :Term
  let g:disable_key_mappings = 1

  Plug 'scrooloose/nerdcommenter'     " Easier block commenting.
  nmap <leader>/ <leader>c<space>
  vmap <leader>/ <leader>c<space>

  " Add test commands
  Plug 'janko-m/vim-test', { 'on': ['TestNearest', 'TestFile', 'TestSuite', 'TestLast', 'TestVisit'] }
  Plug 'kassio/neoterm'
  let g:neoterm_default_mod = 'vert'
  let g:neoterm_size = 80
  let g:neoterm_fixedsize = 1
  let g:neoterm_keep_term_open = 0
  let g:test#strategy = "neoterm"

  function! RunTest(cmd)
    exec a:cmd
  endfunction

  function! RunTestSuite()
    Tclear
    if filereadable('bin/test_suite')
      T echo 'bin/test_suite'
      T bin/test_suite
    elseif filereadable("bin/test")
      T echo 'bin/test'
      T bin/test
    else
      TestSuite
    endif
  endfunction
  nmap <silent> <leader>t :call RunTest('TestNearest')<CR>
  nmap <silent> <leader>T :call RunTest('TestFile')<CR>
  nmap <silent> <leader>a :call RunTestSuite()<CR>
  nmap <silent> <leader>l :call RunTest('TestLast')<CR>
  nmap <silent> <leader>g :call RunTest('TestVisit')<CR>

  Plug 'airblade/vim-gitgutter'       " Git gutter
  Plug 'tpope/vim-fugitive'           " Gblame

  " IEx, Docs, Jump, Mix, deoplete
  "Plug 'slashmili/alchemist.vim', {'for': 'elixir' }
  "let g:alchemist_tag_disable = 1
  Plug 'powerman/vim-plugin-AnsiEsc'  " This fixes some docs
  Plug 'mhinz/vim-mix-format', { 'for': 'elixir' } " Elixir formatting
  let g:mix_format_on_save = 0

  Plug 'tommcdo/vim-lion'             " Align with gl or gL
  Plug 'dkprice/vim-easygrep'         " Grep across files
  Plug 'tpope/vim-endwise'            " Auto-close if, do, def
  Plug 'tpope/vim-surround'           " Add 's' command to give motions context
                                      " eg: `cs"'` will change the surrounding
                                      " double-quotes to single-quotes.

  Plug 'tpope/vim-eunuch'             " Add Bash commands Remove,Move,Find,etc
  Plug 'pbrisbin/vim-mkdir'           " create directories if they don't exist

  Plug 'simeji/winresizer'            " Resize panes with C-e and hjkl

  Plug 'ludovicchabant/vim-gutentags' " Ctags support.

  " FZF and RipGrep
  Plug '/usr/local/opt/fzf'           " Use brew-installed fzf
  Plug 'junegunn/fzf.vim'             " Fuzzy-finder
  nnoremap <C-P> :Files<CR>
  nnoremap <leader>f :RipGrep<Space>
  if executable('fzf')
    set rtp+=/usr/local/opt/fzf " use homebrew-installed fzf
    set grepprg=rg\ --vimgrep   " use ripgrep
    command! -bang -nargs=* RipGrep call fzf#vim#grep('rg --column --line-number --no-heading --fixed-strings --ignore-case --hidden --follow --glob "!.git/**/*" --glob "!.elixir_ls/**/*" --glob "!node_modules/**/*" --glob "!_build/**/*" --glob "!tags" --glob "!priv/static/**/*" --glob "!bower_components/**/*" --glob "!storage/**/*" --glob "!tmp/**/*" --glob "!coverage/**/*" --glob "!deps/**/*" --glob "!.hg/**/*" --glob "!.svn/**/*" --glob "!.sass-cache/**/*" --glob "!public/**/*" --glob "!*.cache" --color "always" '.shellescape(<q-args>), 1, <bang>0)
  endif

  " Cosmetic
  Plug 'ryanoasis/vim-devicons'       " :)
  augroup nerdtreedisablecursorline
    autocmd!
    autocmd FileType nerdtree setlocal nocursorline
  augroup end
  Plug 'crater2150/vim-theme-chroma'  " Theme - Light
  Plug 'Erichain/vim-monokai-pro'     " Theme - Dark
  Plug 'reewr/vim-monokai-phoenix'    " Theme - Darker
  Plug 'itchyny/lightline.vim'        " Statusline
  let g:lightline = {
    \ 'colorscheme': 'wombat',
    \ }
  set noshowmode

  let g:terminal_color_0  = '#151515'
  let g:terminal_color_1  = '#ac4142'
  let g:terminal_color_2  = '#7e8e50'
  let g:terminal_color_3  = '#e5b567'
  let g:terminal_color_4  = '#6c99bb'
  let g:terminal_color_5  = '#9f4e85'
  let g:terminal_color_6  = '#7dd6cf'
  let g:terminal_color_7  = '#d0d0d0'
  let g:terminal_color_8  = '#505050'
  let g:terminal_color_9  = '#ac4142'
  let g:terminal_color_10 = '#7e8e50'
  let g:terminal_color_11 = '#e5b567'
  let g:terminal_color_12 = '#6c99bb'
  let g:terminal_color_13 = '#9f4e85'
  let g:terminal_color_14 = '#7dd6cf'
  let g:terminal_color_15 = '#f5f5f5'

  " Distraction-free writing mode
  Plug 'reedes/vim-colors-pencil', {'for': 'markdown' }      " Theme for markdown editing
  Plug 'reedes/vim-pencil', { 'for': 'markdown' }            " Soft breaks
  Plug 'junegunn/limelight.vim', { 'for': 'markdown' }       " Focus mode
  Plug 'junegunn/goyo.vim', { 'for': 'markdown' }            " ProseMode for writing Markdown
  Plug 'reedes/vim-wordy', { 'for': 'markdown' }             " Weak language checker
  let g:pencil#textwidth = 80
  let g:goyo_width = 80
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

  " Syntax highlighting
  Plug 'sheerun/vim-polyglot'         " Languages support.
  let g:elm_format_autosave = 1
call plug#end()
filetype on

" Theme
set background=dark
colorscheme monokai-phoenix
syntax on

augroup vimrcEx
  autocmd!

  " Open to last line after close
  autocmd BufReadPost *
    \ if &ft != 'gitcommit' && line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  " Set syntax highlighting
  autocmd BufNewFile,BufRead Brewfile setf ruby
  autocmd BufNewFile,BufRead *.md setf markdown
  autocmd BufNewFile,BufRead *.es6 setf javascript
  autocmd BufNewFile,BufRead *.ex* setf elixir
  autocmd BufNewFile,BufRead mix.lock setf elixir
  autocmd BufNewFile,BufRead *.arb setf ruby

  " Enable spellchecking for Markdown
  autocmd FileType markdown setlocal nolist spell foldlevel=999 tw=0 nocin
  let g:vim_markdown_frontmatter = 1

  " Wrap at 80 characters for Markdown
  autocmd BufNewFile,BufRead *.md setlocal textwidth=80

  " Allow stylesheets to autocomplete hyphenated words
  autocmd FileType css,scss,sass setlocal iskeyword+=-

  " Remove trailing whitespace on save
  autocmd BufWritePre * :%s/\s\+$//e

  " Resize panes when window resizes
  autocmd VimResized * :wincmd =
augroup END

augroup TerminalEx
  autocmd TermOpen * setlocal nonumber norelativenumber

  " when in a neovim terminal, add a buffer to the existing vim session
  " instead of nesting (credit justinmk)
  autocmd VimEnter * if !empty($NVIM_LISTEN_ADDRESS) && $NVIM_LISTEN_ADDRESS !=# v:servername
    \ |let g:r=jobstart(['nc', '-U', $NVIM_LISTEN_ADDRESS],{'rpc':v:true})
    \ |let g:f=fnameescape(expand('%:p'))
    \ |noau bwipe
    \ |call rpcrequest(g:r, "nvim_command", "-tabedit ".g:f)
    \ |qa
  \ |endif
augroup END

" Highlight character that marks where line is too long
highlight OverLength ctermbg=red ctermfg=white guibg=#600000
function! UpdateMatch()
  if &previewwindow || &ft !~ '^\%(qf\)$'
    match none
  elseif &ft =~ '^\%(elixir\)$'
    match OverLength /\%101v/
  else
    match OverLength /\%81v/
  endif
endfun
autocmd BufEnter,BufWinEnter * call UpdateMatch()

" Local config
if filereadable($HOME . '/.vimrc.local')
  source ~/.vimrc.local
endif
