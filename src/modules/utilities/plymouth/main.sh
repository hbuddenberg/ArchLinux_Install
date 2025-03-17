#!/bin/bash

clear
# Guardar el valor original de HOME
ORIGINAL_HOME=$HOME

# Verificar si el script se está ejecutando con sudo
function check_sudo() {
  if [ "$EUID" -ne 0 ]; then
    echo -e "\e[31mEste script necesita privilegios de sudo. Solicitando sudo...\e[0m"
    exec sudo HOME=$ORIGINAL_HOME bash "$0" "$@"
    echo "Checking HOME $HOME and $ORIGINAL_HOME"
    read "" > /dev/null
  fi
}

# Verificar si gum está instalado
function check_gum() {
  if ! command -v gum &> /dev/null; then
    echo "gum no está instalado. Instalando gum..."
    pacman -S gum --noconfirm
  fi
}

# Función para limpiar la pantalla
clear_screen() {
    clear
}

# Función para instalar Plymouth
install_plymouth() {
    pacman -Sy --noconfirm plymouth 
    pacman -Sy --noconfirm breeze-plymouth
    gum style --foreground 33 "Plymouth ha sido instalado."
}

# Función para configurar Plymouth
configure_plymouth() {
    # Habilitar Plymouth en el arranque
    sed -i 's/^HOOKS=(.*)/# &\nHOOKS=(base systemd autodetect microcode modconf kms keyboard sd-vconsole block filesystems plymouth)/' /etc/mkinitcpio.conf
    sed -i 's/^MODULES=(.*)/# &\nMODULES=(btrfs i915)/' /etc/mkinitcpio.conf
    sed -i 's/^BINARIES=(.*)/# &\nBINARIES=(\/usr\/bin\/btrfs)/' /etc/mkinitcpio.conf
    sed -i 's/^FILES=(.*)/# &\nFILES=()/' /etc/mkinitcpio.conf

    # Configurar el gestor de arranque
    if [ -f /boot/loader/entries/arch.conf ]; then
        sed -i 's/quiet loglevel=3/quiet splash loglevel=3 vt.global_cursor_default=0/' /boot/loader/entries/arch.conf
    elif [ -f /boot/grub/grub.cfg ]; then
        sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="quiet loglevel=3"/GRUB_CMDLINE_LINUX_DEFAULT="quiet splash loglevel=3 vt.global_cursor_default=0"/' /etc/default/grub
        grub-mkconfig -o /boot/grub/grub.cfg
    fi

    gum style --foreground 33 "Plymouth ha sido configurado."

    # Regenerar las imágenes del initramfs
    sudo mkinitcpio -p linux
}

# Verificar si el usuario es sudo
check_sudo

# Verificar si gum está instalado
check_gum

# Limpiar la pantalla
clear_screen

# Preguntar si se desea instalar Plymouth
if gum confirm "¿Deseas instalar Plymouth?" --affirmative "Sí" --negative "No"; then
    install_plymouth

    # Preguntar si se desea configurar Plymouth
    if gum confirm "¿Deseas configurar Plymouth?" --affirmative "Sí" --negative "No"; then
        configure_plymouth
    fi
fi