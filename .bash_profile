sudo rmmod pcspkr
[[ -f ~/.bashrc ]] && . ~/.bashrc
if [ -z "$DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
    exec startx -- -dpi 144
fi
