#!/bin/bash

REPO="https://github.com/L4ki/Slot-Plasma-Themes"
GTK_THEME="Slot-Spectrum-Dark-GTK"
KVANTUM_THEME="Spectrum-Dark-Kvantum"
ICON_THEME="Slot-Spectrum-Dark-Icons"

echo "Installing slot..."

cd /tmp
rm -rf Slot-Plasma-Themes
git clone --depth 1 "$REPO"
cd Slot-Plasma-Themes

# GTK
mkdir -p ~/.themes
cp -r "Slot GTK Themes/$GTK_THEME" ~/.themes/

mkdir -p ~/.config/gtk-3.0
cat > ~/.config/gtk-3.0/settings.ini << EOF
[Settings]
gtk-theme-name=$GTK_THEME
gtk-icon-theme-name=$ICON_THEME
gtk-application-prefer-dark-theme=1
EOF

mkdir -p ~/.config/gtk-4.0
cat > ~/.config/gtk-4.0/settings.ini << EOF
[Settings]
gtk-theme-name=$GTK_THEME
gtk-icon-theme-name=$ICON_THEME
gtk-application-prefer-dark-theme=1
EOF

cat > ~/.gtkrc-2.0 << EOF
gtk-theme-name="$GTK_THEME"
gtk-icon-theme-name="$ICON_THEME"
EOF

# Kvantum
mkdir -p ~/.config/Kvantum
cp -r "Slot Kvantum Themes/$KVANTUM_THEME" ~/.config/Kvantum/

cat > ~/.config/Kvantum/kvantum.kvconfig << EOF
[General]
theme=$KVANTUM_THEME
EOF

# Icons
mkdir -p ~/.icons
cp -r "Slot Icons Themes/$ICON_THEME" ~/.icons/

echo "Done installing slot."
