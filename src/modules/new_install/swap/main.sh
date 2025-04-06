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

# Obtener la ruta del directorio del script actual
SCRIPT_DIR=$(dirname "${BASH_SOURCE[0]}")

# Función para configurar swap zram
function configure_swap_zram() {
    echo "Configurando swap zram..."
    read -p "¿Deseas configurar swap zram? (s/n) [n]: " configure_swap
    configure_swap=${configure_swap:-n}
    if [[ "$configure_swap" == "s" || "$configure_swap" == "S" ]]; then
        read -p "Introduce el tamaño de la swap zram en GB [8]: " swap_size
        swap_size=${swap_size:-8}
        pacman -S --noconfirm zram-generator bc
        echo -e "[zram0]\nzram-size = ${swap_size}G\ncompression-algorithm = zstd" | tee /etc/systemd/zram-generator.conf
        systemctl daemon-reload
        systemctl start /dev/zram0
        echo "---------------------------------------------------"
    fi
}

# Función para configurar swap en archivo BTRFS
function configure_swap_btrfs() {
    echo "Configurando swap en archivo BTRFS..."
    read -p "¿Deseas configurar swap en un archivo BTRFS? (s/n) [n]: " configure_btrfs_swap
    configure_btrfs_swap=${configure_btrfs_swap:-n}
    if [[ "$configure_btrfs_swap" == "s" || "$configure_btrfs_swap" == "S" ]]; then
        read -p "Introduce el tamaño del archivo de swap en GB [8]: " swap_size
        pacman -S --noconfirm bc
        swap_size=${swap_size:-8}
        btrfs subvolume create /.swap
        truncate -s 0 /.swap/swapfile
        chattr +C /mnt/.swap/swapfile
        dd if=/dev/zero of=/.swap/swapfile bs=1M count=$(echo "$swap_size * 1024" | bc)
        chmod 600 /.swap/swapfile
        mkswap /.swap/swapfile
        swapon /.swap/swapfile
        echo "/.swap/swapfile none swap defaults 0 0" | tee -a /etc/fstab
        echo "---------------------------------------------------"
    fi
}

# Función principal
function main() {
    configure_swap_zram
    configure_swap_btrfs
    
    echo "Saliendo..."
}

# Ejecutar la función principal
main