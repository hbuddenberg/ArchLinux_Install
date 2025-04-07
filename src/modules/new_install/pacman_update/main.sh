#!/bin/bash
clear

# Función para verificar si estamos en un entorno Live ISO
function is_live_iso {
    if grep -q "overlay" /etc/mtab; then
        return 0  # Está en un Live ISO
    else
        return 1  # No está en un Live ISO
    fi
}

# Verificar si gum está instalado
if ! command -v gum &> /dev/null; then
    echo "gum no está instalado. Intentando liberar espacio y luego instalar gum..."
    
    # Verificar si estamos en un entorno Live ISO
    if is_live_iso; then
        echo "Detectado entorno Live ISO. Liberando espacio automáticamente..."
        sudo rm -rf /var/cache/pacman/pkg/*
    else
        echo "No se detectó un entorno Live ISO. No se realizará la limpieza automática."
    fi

    # Intentar instalar gum
    if command -v pacman &> /dev/null; then
        echo "Instalando gum..."
        sudo pacman -S --noconfirm gum
    else
        echo "No se pudo instalar gum. Por favor, instálalo manualmente."
        exit 1
    fi
fi

# Usar gum para validar si el script está siendo ejecutado como superusuario
if [[ $EUID -ne 0 ]]; then
    gum style --foreground 212 "Este script requiere permisos de superusuario."
    if gum confirm "¿Quieres reiniciar el script con 'sudo'?" --affirmative "Sí" --negative "No"; then
        exec sudo bash "$0" "$@"
    else
        gum style --foreground 9 "No se puede continuar sin permisos de superusuario. Saliendo..."
        exit 1
    fi
fi

# Aquí continúa el resto del script...
gum style --foreground 10 "¡Permisos de superusuario detectados! Continuando con el script..."

clear 

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

# Preguntar si se desea usar reflector con un encabezado claro
USE_REFLECTOR=$(gum choose --header "¿Quieres usar Reflector para optimizar los mirrors de Arch Linux?" "Sí, optimizar mirrors" "No, continuar sin optimizar")
if [[ "$USE_REFLECTOR" == "Sí, optimizar mirrors" ]]; then
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