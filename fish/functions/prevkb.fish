# Hyprland prevkb function
function prevkb
    set kb (hyprctl devices -j | jq -r '.keyboards[] | select(.main) | .name')
    hyprctl switchxkblayout $kb prev
end
