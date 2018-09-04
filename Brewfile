tap 'Goles/battery'
tap 'neovim/neovim'
tap 'thoughtbot/formulae'

# This should be installed manually
# https://www.google.com/chrome/
# cask 'google-chrome'  # Internet browser
# cask 'google-backup-and-sync'   # File syncing
# cask 'kitty'          # Terminal emulator

# This should be installed manually.
# https://1password.com/downloads/
# cask '1password'    # Password manager

if RUBY_PLATFORM.downcase.include? 'darwin'
  tap 'caskroom/cask'
  tap 'caskroom/fonts'
  tap 'caskroom/versions'
  cask 'alfred'         # Spotlight replacement
  cask 'android-file-transfer'  # Transfer files from/to Android
  cask 'boxer'          # DOS Emulator
  cask 'chromedriver'   # Headless browser
  cask 'dash'           # Offline documentation
  cask 'font-firacode-nerd-font' # Fira Mono font with code ligatures and icons
  cask 'font-inconsolatago-nerd-font' # Inconsolata-g (straight quotes) with icons
  cask 'handbrake'      # Video/audio processing
  cask 'handbrakebatch' # Batch video/audio processing with handbrake
  cask 'hex-fiend'      # Hex value editor
  cask 'insomniax'      # Prevent computer from sleeping
  cask 'keep'           # Notes in the menubar
  cask 'omnidisksweeper'  # Disk visualizer
  cask 'omnigraffle6'   # Graphing app
  cask 'pdftotext'      # CLI for converting PDF to Text. Used for Ranger
  cask 'postico'        # Postgres Database Viewer
  cask 'postman'        # REST app
  cask 'slack'          # Chat
  cask 'sourcetree'     # Git manager
  cask 'transmission'   # Bittorrent
  cask 'virtualbox'     # Virtual Machine manager
  cask 'vlc'            # Video/Audio Player
  cask 'wkhtmltopdf'    # CLI wkhtmltopdf Convert HTML to PDFs
  cask 'xld'            # Audio processing
  brew 'autoconf'       # CLI Build utility
  brew 'automake'       # CLI Build utility
  brew 'ccat'           # CLI utility. Colorized cat
  brew 'coreutils'      # CLI GNU utilities
  brew 'htop-osx'       # CLI htop process utility
  brew 'reattach-to-user-namespace' # CLI to help tmux and mac
  brew 'wxmac'          # Library for Erlang debugger to render GUI
  brew 'mas'            # CLI to install from Mac App Store
  brew 'unixodbc'       # Library for interfacing with different databases
  brew 'dnsmasq', restart_service: :changed

  # This is too big and should be installed on it's own first.
  # https://itunes.apple.com/us/app/xcode/id497799835?mt=12
  # mas 'Xcode',          id: 497799835

  mas 'The Unarchiver', id: 425424353
  mas 'Medis',          id: 1063631769
  mas 'GIPHY Capture',  id: 668208984
  mas 'Harvest',        id: 506189836
  mas 'Calendarique',   id: 1040634920
end

brew 'atool'          # CLI. Archives inspection. Used for Ranger.
brew 'battery'        # CLI for showing battery level, used for tmux
brew 'cmake'          # CLI Build utility
brew 'ctags'          # CLI Exhuburant ctags
brew 'dfu-util'       # CLI Firmware loader for keyboard
brew 'diff-so-fancy'  # CLI diff-highlight for git
brew 'exercism'       # CLI exercism.io
brew 'exiftool'       # CLI. Image file metadata inspection. Used for Ranger.
brew 'ffmpeg'         # CLI ffmpeg Media encoder/decoder
brew 'fontconfig'     # CLI fontconfig Font utility for patching fonts
brew 'freetype'       # Library Render fonts
brew 'fzf'            # CLI Fuzzy Finder CLI
brew 'ghostscript'    # CLI Produce PDFs
brew 'git'            # CLI Git version control
brew 'git-flow'       # CLI Git-Flow git shortcuts
brew 'glib'           # Library Build utility
brew 'googler'        # CLI google from command line
brew 'gpg'            # CLI GPG security
brew 'heroku'         # CLI heroku
brew 'highlight'      # Library. Provides syntax highlighting. Used for Ranger
brew 'hub'            # CLI add commands to git
brew 'imagemagick'    # CLI magick Image converter CLI
brew 'lame'           # Library audio encoder/decoder
brew 'libxml2'        # Library XML parsing
brew 'libyaml'        # Library for parsing YAML
brew 'mediainfo'      # CLI. Media file metadata inspection. Used for Ranger.
brew 'neovim'         # CLI nvim text editor
brew 'openssl'        # Library SSL library
brew 'p7zip'          # CLI 7a 7za compression
brew 'parity'         # CLI adding commands to heroku
brew 'phantomjs'      # CLI phantomjs headless webkit browser (for testing)
brew 'qt@5.5'         # Library qt. Used for Capybara
brew 'ranger'         # CLI Ranger File Explorer
brew 'readline'       # Library file reading
brew 'ripgrep'        # CLI rg grep current directory
brew 'rsync'          # CLI rsync file copying
brew 'shellcheck'     # CLI POSIX shell linter
brew 'sqlite'         # Service Database
brew 'tesseract'      # CLI tesseract OCR
brew 'tidy-html5'     # CLI tidy HTML linting
brew 'tldr'           # CLI tldr short man pages
brew 'tmate'          # CLI tmate tmux over SSH
brew 'tmux'           # CLI tmux terminal multiplexer
brew 'unrar'          # CLI unrar compression
brew 'wget'           # CLI wget HTTP interface
brew 'wrk'            # CLI wrk HTTP benchmarking
brew 'x264'           # Library video decoder
brew 'xz'             # CLI xz compression
brew 'yarn'           # CLI JavaScript package manager

# Services
brew 'postgresql', restart_service: :changed
brew 'redis', restart_service: :changed
brew 'nginx', restart_service: :changed
