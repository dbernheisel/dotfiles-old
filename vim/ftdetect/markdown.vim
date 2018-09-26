" Distraction-free writing mode
let g:pencil#textwidth = 80
let g:goyo_width = 80
let g:vim_markdown_frontmatter = 1

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

" Highlight character that marks where line is too long
highlight OverLength ctermbg=red ctermfg=white guibg=#600000
function! UpdateMatch()
  if &previewwindow || &ft !~ '^\%(qf\)$'
    match none
  else
    match OverLength /\%81v/
  endif
endfun
autocmd BufEnter,BufWinEnter * call UpdateMatch()

autocmd! User GoyoEnter nested call <SID>goyo_enter()
autocmd! User GoyoLeave nested call <SID>goyo_leave()
nmap <leader>df :Goyo<CR>

" Enable spellchecking for Markdown
setlocal nolist
setlocal spell
setlocal foldlevel=999
setlocal nocindent
setlocal textwidth=80
