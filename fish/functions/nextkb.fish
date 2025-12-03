# Hyprland nextkb function
function nextkb
    set kb (hyprctl devices -j | jq -r '.keyboards[] | select(.main) | .name')
    hyprctl switchxkblayout $kb next
end
