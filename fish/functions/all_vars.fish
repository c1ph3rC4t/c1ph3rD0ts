function all_vars
    for var in (set -n)
        echo -e "$var: $$var"
    end
end
