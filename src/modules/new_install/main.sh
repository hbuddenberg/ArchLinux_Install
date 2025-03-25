#!/bin/bash
# Verifica si el script se ejecuta como root
if [[ $EUID -ne 0 ]]; then
    echo "Este script debe ejecutarse como root" 
    exit 1
fi

clear

# Obtener el directorio del script
SCRIPT_DIR=$(dirname "${BASH_SOURCE[0]}")

# Variable para controlar si se ejecuta de corrido
ejecutar_de_corrido=false

# Función para mostrar el menú principal
function show_menu {
    clear
    echo "==========================================="
    echo " ArchHypr Install - Menú Principal"
    echo "==========================================="
    echo "1) Configurar Fecha y Hora"
    echo "2) Actualizar Pacman"
    echo "3) Crear Particiones"
    echo "4) Instalar Arch Linux"
    echo "5) Instalar usando Archinstall"
    echo "6) Post-Instalación de Arch Linux"
    echo "0) Salir"
    echo "==========================================="
    echo "Presione Enter para ejecutar todas las opciones en secuencia"
    echo "==========================================="
    read -p "Seleccione una opción: " opcion
}

# Función para ejecutar el módulo de configuración de fecha y hora
function configurar_fecha_hora {
    bash "$SCRIPT_DIR/modules/date_time_zone/main.sh"
    if [ "$1" != "no_wait" ]; then
        read -p "Presione Enter para continuar..."
    fi
}

# Función para ejecutar el módulo de creación de particiones
function crear_particiones {
    bash "$SCRIPT_DIR/modules/partitions/main.sh"
    if [ "$1" != "no_wait" ]; then
        read -p "Presione Enter para continuar..."
    fi
}

# Función para actualizar pacman
function pacman_update {
    bash "$SCRIPT_DIR/modules/pacman_update/main.sh"
    if [ "$1" != "no_wait" ]; then
        read -p "Presione Enter para continuar..."
    fi
}

# Función para ejecutar el módulo de instalación de Arch Linux
function instalar_arch_linux {
    bash "$SCRIPT_DIR/modules/install_arch/main.sh"
    if [ "$1" != "no_wait" ]; then
        read -p "Presione Enter para continuar..."
    fi
}

# Función para ejecutar el módulo de instalación usando Archinstall
function instalar_usando_archinstall {
    bash "$SCRIPT_DIR/modules/install_by_archinstall/main.sh"
    if [ "$1" != "no_wait" ]; then
        read -p "Presione Enter para continuar..."
    fi
}

# Función para ejecutar el módulo de post-instalación de Arch Linux
function post_install_arch {
    bash "$SCRIPT_DIR/modules/post_install/main.sh"
    if [ "$1" != "no_wait" ]; then
        read -p "Presione Enter para continuar..."
    fi
}

# Función para ejecutar todos los módulos en secuencia
function ejecutar_todos {
    ejecutar_de_corrido=true
    crear_particiones no_wait
    instalar_arch_linux no_wait
    post_install_arch no_wait
    ejecutar_de_corrido=false
}

# Bucle principal del menú
while true; do
    show_menu
    case $opcion in
        1)
            configurar_fecha_hora
            ;;
        2)
            pacman_update
            ;;
        3)
            crear_particiones
            ;;
        4)
            instalar_arch_linux
            ;;
        5)
            instalar_usando_archinstall
            ;;
        6)
            post_install_arch
            ;;
        0)
            echo "Saliendo..."
            exit 0
            ;;
        "")
            ejecutar_todos
            ;;
        *)
            echo "Opción inválida, intente nuevamente."
            sleep 2
            ;;
    esac
    read -p "Presione Enter finalizar..."
done