function node_repl
    while true
        read -f -P "[node]# " input
        if test $input = ""
            break
        end
        node -e "console.log($input)"
    end
end
