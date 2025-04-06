#!/bin/bash

set -euo pipefail

# Verifica si el script se ejecuta como root
if [[ $EUID -ne 0 ]]; then
    echo "Este script debe ejecutarse como root. Reintentando como root..."
    exec sudo "$0" "$@"
fi

# Verifica si gum está instalado, si no, lo instala
if ! command -v gum &> /dev/null; then
    echo "gum no está instalado. Instalándolo..."
    pacman -Sy --noconfirm gum
fi

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
    generate_fstab
    gum style --foreground 212 --bold "---------------------------------------------------"
    gum style --foreground 212 --bold "Ejecutando el script de post-instalación..."
    bash "$(dirname "$0")/../install_arch/main.sh"
}

# Ejecutar la función principal
main