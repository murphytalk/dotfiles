if [ -e "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/zprofile ];then
    . "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/zprofile
fi
if [ -e "${ZDOTDIR:-$HOME}"/.profile ];then
    . "${ZDOTDIR:-$HOME}"/.profile
fi
