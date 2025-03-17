#!/bin/bash

clear
# Verificar si el script se está ejecutando con sudo
function check_sudo() {
  if [ "$EUID" -ne 0 ]; then
    echo -e "\e[31mEste script necesita privilegios de sudo. Solicitando sudo...\e[0m"
    exec sudo bash "$0" "$@"
  fi
}

# Verificar si gum está instalado
function check_gum() {
  if ! command -v gum &> /dev/null; then
    echo "gum no está instalado. Instalando gum..."
    sudo pacman -S gum --noconfirm
  fi
}

# Instalar dependencias necesarias
function install_dependencies() {
  gum style --foreground 33 "Instalando dependencias necesarias..."
  sudo pacman -S --noconfirm libvncserver gtk-vnc spice-gtk freerdp webkit2gtk libsecret kwalletmanager xorg-server-xwayland gtk4
}

# Instalar Remmina
function install_remmina() {
  if ! command -v remmina &> /dev/null; then
    gum style --foreground 33 "Remmina no está instalado. Instalando Remmina..."
    sudo pacman -S remmina --noconfirm
  else
    gum style --foreground 33 "Remmina ya está instalado."
  fi
}

# Instalar conectores adicionales
function install_commons_connectors() {
  if gum confirm --selected.foreground="32" --unselected.foreground="196" --prompt.foreground="21" --prompt.bold "¿Deseas instalar conectores para RustDesk, AnyDesk, TeamViewer para Remmina?"; then
    gum style --foreground 32 "Instalando conectores adicionales..."
    yay -Sy --noconfirm remmina-plugin-rustdesk remmina-plugin-anydesk-git remmina-plugin-teamviewer
  else
    gum style --foreground 196 "Instalación de conectores RustDesk, AnyDesk, TeamViewer omitida."
  fi
}

# Instalar conectores adicionales
function install_connectors() {
  if gum confirm --selected.foreground="32" --unselected.foreground="196" --prompt.foreground="21" --prompt.bold "¿Deseas instalar otros conectores adicionales para Remmina?"; then
    gum style --foreground 32 "Instalando conectores adicionales..."
    yay -Sy --noconfirm remmina-plugin-ultravnc remmina-plugin-folder remmina-plugin-url remmina-plugin-open remmina-plugin-rdesktop
  else
    gum style --foreground 196 "Instalación de conectores adicionales omitida."
  fi
}

# Ejecutar funciones
check_sudo "$@"
check_gum
install_dependencies
install_remmina
install_commons_connectors
install_connectors

gum style --foreground 32 "Instalación completada."