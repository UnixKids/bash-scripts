# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
        . ~/.bashrc
fi

if [ -f ~/.bash_alias ]; then
        . ~/.bash_alias
fi
# User specific environment and startup programs

PATH=$PATH:$HOME/bin

export PATH
