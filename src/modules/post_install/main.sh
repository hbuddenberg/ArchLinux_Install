#!/bin/bash
clear
# Verifica si el script se ejecuta como root
if [[ $EUID -ne 0 ]]; then
    echo "Este script debe ejecutarse como root" 
    exit 1
fi

# Obtener la ruta del directorio del script actual de forma dinámica
SCRIPT_DIR=$(dirname "$(realpath "$BASH_SOURCE")")
echo "directorio actual: $SCRIPT_DIR"

# Función para configurar el sistema dentro del chroot
function configure_system() {

    # Ejecutar los comandos directamente dentro del entorno chroot
    arch-chroot /mnt /bin/bash -c "
pacman --noconfirm -Sy git
cd /tmp
git clone -b develop https://github.com/HansBuddenbergBlamey/ArchLinux_install.git
git reset --hard HEAD
git pull origin develop
chmod +x ArchHypr_Install/src/modules/post_install/chroot_commands.sh
sh ArchHypr_Install/src/modules/post_install/chroot_commands.sh
"

    echo "---------------------------------------------------"
}

# Función para desmontar las particiones
function unmount_partitions() {
    read -p "¿Desea desmontar las particiones ahora? (s/n) [s]: " UNMOUNT_NOW
    UNMOUNT_NOW=${UNMOUNT_NOW:-s}
    if [[ $UNMOUNT_NOW == "s" ]]; then
        echo "Desmontando las particiones..."
        umount -R /mnt || umount -l /mnt
        echo "---------------------------------------------------"
    else
        echo "Las particiones no se desmontaron."
    fi
}

# Función para reiniciar el sistema
function restart() {
    read -p "¿Desea reiniciar el sistema ahora? (s/n) [s]: " RESTART_NOW
    RESTART_NOW=${RESTART_NOW:-s}
    if [[ $RESTART_NOW == "s" ]]; then
        read -p "Presiona Enter para reiniciar el sistema..."
        reboot now
    else
        echo "El sistema no se reinició."
    fi
}

# Función principal
function main() {
    configure_system
    unmount_partitions
    restart
    echo "---------------------------------------------------"
}

# Ejecutar la función principal
main