#!/usr/bin/env bash
set -euo pipefail
# Verifica si el script se ejecuta como root
if [[ $EUID -ne 0 ]]; then
    echo "Este script debe ejecutarse como root" 
    exit 1
fi

clear

# Función para instalar los paquetes base
function install_base_packages() {
    echo "Instalando los paquetes base..."
    #pacstrap -K /mnt base base-devel btrfs-progs linux linux-firmware dhcpcd vim git intel-ucode
    pacstrap -K /mnt base base-devel btrfs-progs linux linux-firmware dhcpcd openssh vim git intel-ucode --overwrite '*'
    echo "---------------------------------------------------"
}

# Función para generar el archivo fstab
function generate_fstab() {
    echo "Generando el archivo fstab..."
    genfstab -U /mnt >> /mnt/etc/fstab
    echo "---------------------------------------------------"
}

# Función principal
function main() {
    install_base_packages
    generate_fstab
    echo "---------------------------------------------------"
}

# Ejecutar la función principal
main