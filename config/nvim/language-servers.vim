let g:LanguageClient_autoStart = 1
let g:LanguageClient_serverCommands = {}

nnoremap <silent> <c-]> :call LanguageClient#textDocument_definition()<CR>

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

if executable('language_server.sh')
  " git clone git@github.com:JakeBecker/elixir-ls.git ~/.elixir_ls
  " cd ~/.elixir_ls
  " mix deps.get && mix compile
  " mix elixir_ls.release - .
  " add it to the $PATH

  let g:LanguageClient_serverCommands.elixir = ['language_server.sh']
endif

if executable('kotlin-language-server')
  " git clone git@github.com:fwcd/KotlinLanguageServer.git ~/.kotlin_ls
  " cd ~/.kotlin_ls
  " ./gradlew installDist
  " export ~/.kotlin_ls/build/install/kotlin-language-server/bin/ to the $PATH
  let g:LanguageClient_serverCommands.kotlin = ['kotlin-language-server']
endif

if executable('pyls')
  " pip install python-language-server
  let g:LanguageClient_serverCommands.python = ['pyls']
endif

if executable('solargraph')
  " gem install solargraph
  let g:LanguageClient_serverCommands.ruby = ['solargraph', 'stdio']
endif
