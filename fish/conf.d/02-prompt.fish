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
