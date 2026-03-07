function fish_prompt
    set_color blue
    echo -n $USER
    set_color brblue
    echo -n @
    set_color blue
    echo -n (prompt_hostname)
    set_color brblue
    echo -n :
    set_color blue
    echo -n (prompt_pwd)
    set_color magenta
    echo -n 'λ'
    set_color normal
    echo -n ' '
end

if $IS_TTY
    if not $IS_TMUX
        exec tmux
    end
else if not $IS_TMUX
    if command -q starship
        function starship_transient_prompt_func
            set_color 8caaee
            echo -n ""
            set_color normal

            starship module directory

            set_color 8caaee
            echo -n "─"
            set_color normal

            starship module character
        end
        starship init fish | source
        enable_transience
    end
end
