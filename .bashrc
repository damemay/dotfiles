[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias pacman-clean='sudo pacman -Rsn $(pacman -Qdtq)'
alias boot-win='systemctl reboot --boot-loader-entry=auto-windows'
PS1="┌─\u@\h \e[3m\e[2;90m\w\e[23m\e[0m\n└ \e[1;$(($RANDOM%7+90))m\$\e[0m "
source ~/.local/share/blesh/ble.sh
