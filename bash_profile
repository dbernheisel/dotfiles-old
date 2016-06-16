##
# Your previous /Users/bernheisel/.bash_profile file was backed up as /Users/bernheisel/.bash_profile.macports-saved_2013-01-25_at_21:52:28
##

# Setting PATH for Python 3.3
# The orginal version is saved in .bash_profile.pysave
PATH="/Library/Frameworks/Python.framework/Versions/3.3/bin:${PATH}"
export PATH

# Setting PATH for Python 2.7
# The orginal version is saved in .bash_profile.pysave
PATH="/Library/Frameworks/Python.framework/Versions/2.7/bin:${PATH}"
export PATH

##
# Your previous /Users/bernheisel/.bash_profile file was backed up as /Users/bernheisel/.bash_profile.macports-saved_2013-12-15_at_14:28:23
##

# MacPorts Installer addition on 2013-12-15_at_14:28:23: adding an appropriate PATH variable for use with MacPorts.
export PATH=/opt/local/bin:/opt/local/sbin:$PATH
# Finished adapting your PATH environment variable for use with MacPorts.

if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi
case $- in
   *i*) source ~/.bashrc
esac

source ~/.zprofile