#!/bin/bash
clear

################################################################
# Verifica si el script se ejecuta como root
if [[ $EUID -ne 0 ]]; then
    echo "Este script debe ejecutarse como root" 
    exit 1
fi

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