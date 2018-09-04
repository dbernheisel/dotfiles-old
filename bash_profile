export PATH=/opt/local/bin:/opt/local/sbin:$PATH

case $- in
   *i*) source ~/.bashrc
esac

if [ -d "$HOME/.cargo/bin" ]; then
  export PATH="$HOME/.cargo/bin:$PATH"
fi
