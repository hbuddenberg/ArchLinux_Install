#!/bin/bash
clear
# Verifica si el script se ejecuta como root
if [[ $EUID -ne 0 ]]; then
    echo "Este script debe ejecutarse como root"
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

echo "Cambios aplicados a $PACMAN_CONF"

# Preguntar si se desea usar reflector
read -p "¿Desea usar reflector para actualizar la lista de mirrors? (S/n): " USE_REFLECTOR
USE_REFLECTOR=${USE_REFLECTOR:-s}
if [[ "$USE_REFLECTOR" =~ ^[Ss]$ ]]; then
    ## Reflector
    DEFAULT_COUNTRY="Chile"
    read -p "Ingrese el país para reflector (predeterminado: Chile): " COUNTRY
    COUNTRY=${COUNTRY:-$DEFAULT_COUNTRY}

    # Verificar conectividad a Internet
    pacman --noconfirm -Sy reflector rsync

    # Probar reflector con el país especificado
    if reflector -c "$COUNTRY,Worldwide," -p https -a 10 --sort rate; then
        # Si reflector responde correctamente, guardar en el archivo de mirrors
        reflector -c "$COUNTRY,Worldwide," -p https -a 10 --sort rate --save /etc/pacman.d/mirrorlist
    else
        echo "Reflector no pudo obtener mirrors para el país especificado."
        exit 1
    fi
fi

pacman-key --init
pacman-key --populate archlinux
pacman -Syy