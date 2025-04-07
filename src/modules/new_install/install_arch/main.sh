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

# Función para instalar los paquetes base
function install_base_packages() {
    gum style --foreground 212 --bold "Instalando los paquetes base..."
    pacstrap -K /mnt base base-devel btrfs-progs linux linux-firmware dhcpcd openssh vim git intel-ucode --overwrite '*'
    gum style --foreground 212 --bold "---------------------------------------------------"
}

# Función para generar el archivo fstab
function generate_fstab() {
    gum style --foreground 212 --bold "Generando el archivo fstab..."
    genfstab -U /mnt >> /mnt/etc/fstab
    gum style --foreground 212 --bold "---------------------------------------------------"
}

# Función principal
function main() {
    install_base_packages
    continue
    generate_fstab
    continue
    gum style --foreground 212 --bold "---------------------------------------------------"
    gum style --foreground 212 --bold "Ejecutando el script de post-instalación..."
    bash "$(dirname "$0")/../install_arch/main.sh"
    continue
}

# Ejecutar la función principal
main