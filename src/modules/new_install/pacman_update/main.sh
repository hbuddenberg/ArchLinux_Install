#!/bin/bash
clear
# Verifica si el script se ejecuta como root
if [[ $EUID -ne 0 ]]; then
    gum style --foreground 196 "Este script debe ejecutarse como root"
    exit 1
fi

PACMAN_CONF="/etc/pacman.conf"

# Reemplazar #Color por Color
sed -i 's/^#Color/Color/' "$PACMAN_CONF"

# Agregar ILoveCandy después de #DisableSandbox si no existe
if ! grep -q "^ILoveCandy" "$PACMAN_CONF"; then
    sed -i '/^#DisableSandbox/a ILoveCandy' "$PACMAN_CONF"
fi

# Descomentar [multilib] y su Include
sed -i '/^#\[multilib\]/{N;s/#\(\[multilib\]\)\n#\(Include = \/etc\/pacman.d\/mirrorlist\)/\1\n\2/}' "$PACMAN_CONF"

gum style --foreground 34 "Cambios aplicados a $PACMAN_CONF"

# Preguntar si se desea usar reflector
USE_REFLECTOR=$(gum choose "Sí" "No")
if [[ "$USE_REFLECTOR" == "Sí" ]]; then
    ## Reflector
    DEFAULT_COUNTRY="Chile"
    COUNTRY=$(gum input --placeholder "Ingrese el país para reflector (predeterminado: Chile)")
    COUNTRY=${COUNTRY:-$DEFAULT_COUNTRY}

    # Verificar conectividad a Internet
    pacman --noconfirm -Sy reflector rsync

    # Probar reflector con el país especificado
    if reflector -c "$COUNTRY,Worldwide," -p https -a 10 --sort rate; then
        # Si reflector responde correctamente, guardar en el archivo de mirrors
        reflector -c "$COUNTRY,Worldwide," -p https -a 10 --sort rate --save /etc/pacman.d/mirrorlist
    else
        gum style --foreground 196 "Reflector no pudo obtener mirrors para el país especificado."
        exit 1
    fi
fi

pacman-key --init
pacman-key --populate archlinux
pacman -Syy