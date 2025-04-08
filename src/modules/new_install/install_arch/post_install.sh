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

# Obtener la ruta del directorio del script actual de forma dinámica
if [ -z "$SCRIPT_DIR" ]; then
    SCRIPT_DIR=$(dirname "$(realpath "$BASH_SOURCE")")
fi
SCRIPT_DIR_ORIGINAL=$SCRIPT_DIR
echo "directorio actual: $SCRIPT_DIR"

# Función para configurar el sistema dentro del chroot
function configure_system() {

    # Ejecutar los comandos directamente dentro del entorno chroot
    SCRIPT_DIR="/tmp/ArchLinux_Install"
    arch-chroot /mnt /bin/bash -c "
clear
pacman --noconfirm -Sy git
cd /tmp
git clone -b develop https://github.com/HansBuddenbergBlamey/ArchLinux_Install.git
cd /tmp/ArchLinux_Install
git reset --hard HEAD
git pull origin main
chmod +x /tmp/ArchLinux_Install/src/modules/new_install/post_install/main.sh
sh /tmp/ArchLinux_Install/src/modules/new_install/post_install/main.sh
chmod +x /tmp/ArchLinux_Install/src/modules/new_install/swap/main.sh
sh /tmp/ArchLinux_Install/src/modules/new_install/swap/main.sh
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