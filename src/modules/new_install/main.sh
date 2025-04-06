#!/bin/bash

# Verificar si gum está instalado
if ! command -v gum &> /dev/null; then
    echo "gum no está instalado. Instalando gum..."
    if command -v pacman &> /dev/null; then
        sudo pacman -S --noconfirm gum
    else
        echo "No se pudo instalar gum. Por favor, instálalo manualmente."
        exit 1
    fi
fi

# Obtener el directorio del script
SCRIPT_DIR=$(dirname "${BASH_SOURCE[0]}")

# Colores Gameboy
HEX_DARK_GREEN="#0f380f"
HEX_GREEN="#306230"
HEX_LIGHT_GREEN="#8bac0f"
HEX_LIGHTEST_GREEN="#9bbc0f"

# Colores Arch Linux
HEX_ARCH_BLUE="#1793D1"
HEX_ARCH_CYAN="#00FFFF"
HEX_ARCH_WHITE="#FFFFFF"

ARCH_BLUE="\033[38;2;23;147;209m"
ARCH_CYAN="\033[1;36m"
ARCH_WHITE="\033[1;37m"
ARCH_RESET="\033[0m"

# Logo de Arch Linux
ARCH_LOGO="${ARCH_BLUE}                   ▄\n"
ARCH_LOGO+="${ARCH_BLUE}                  ▟█▙\n"
ARCH_LOGO+="${ARCH_BLUE}                 ▟███▙\n"
ARCH_LOGO+="${ARCH_BLUE}                ▟█████▙\n"
ARCH_LOGO+="${ARCH_BLUE}               ▟███████▙\n"
ARCH_LOGO+="${ARCH_BLUE}              ▂▔▀▜██████▙\n"
ARCH_LOGO+="${ARCH_BLUE}             ▟██▅▂▝▜█████▙\n"
ARCH_LOGO+="${ARCH_BLUE}            ▟█████████████▙             ${ARCH_WHITE}               #     ${ARCH_CYAN}| *\n"
ARCH_LOGO+="${ARCH_BLUE}           ▟███████████████▙            ${ARCH_WHITE} a##e #%\" a#\"e 6##%  ${ARCH_CYAN}| | |-^-. |   | \\ /\n"
ARCH_LOGO+="${ARCH_BLUE}          ▟█████████████████▙           ${ARCH_WHITE}.oOo# #   #    #  #  ${ARCH_CYAN}| | |   | |   |  X\n"
ARCH_LOGO+="${ARCH_BLUE}         ▟███████████████████▙          ${ARCH_WHITE}%OoO# #   %#e\" #  #  ${ARCH_CYAN}| | |   | ^._.| / \\ ${ARCH_WHITE}TM \n"
ARCH_LOGO+="${ARCH_BLUE}        ▟█████████▛▀▀▜████████▙\n"
ARCH_LOGO+="${ARCH_BLUE}       ▟████████▛      ▜███████▙\n"
ARCH_LOGO+="${ARCH_BLUE}      ▟█████████        ████████▙\n"
ARCH_LOGO+="${ARCH_BLUE}     ▟██████████        █████▆▅▄▃▂\n"
ARCH_LOGO+="${ARCH_BLUE}    ▟██████████▛        ▜█████████▙                    ${ARCH_WHITE}Menú ${ARCH_CYAN}Instalación${ARCH_WHITE}:\n"
ARCH_LOGO+="${ARCH_BLUE}   ▟██████▀▀▀              ▀▀██████▙                   =================\n"
ARCH_LOGO+="${ARCH_BLUE}  ▟███▀▘                       ▝▀███▙\n"
ARCH_LOGO+="${ARCH_BLUE} ▟▛▀                               ▀▜▙\n"
ARCH_LOGO+="${ARCH_RESET}"

# Variable para controlar si se ejecuta de corrido
ejecutar_de_corrido=false

# Función para mostrar el menú principal
function show_menu {
    clear
    echo -e "$ARCH_LOGO" | gum style --no-strip-ansi --border thick --margin "1" --padding "1" --border-foreground "$HEX_ARCH_CYAN" --foreground "$HEX_ARCH_WHITE" --bold
    opcion=$(gum choose --cursor.foreground="$HEX_ARCH_CYAN" --cursor.bold --selected.foreground="$HEX_ARCH_WHITE" --selected.bold --header="Seleccione:" --header.foreground="$HEX_ARCH_BLUE" --header.bold \
        "● Ejecucion de corrido" \
        "● Actualizar Pacman" \
        "● Crear Particiones" \
        "● Instalar Arch Linux" \
        "● Instalar usando Archinstall" \
        "● Post-Instalación de Arch Linux" \
        "○ Salir")
}

# Función para ejecutar el módulo de configuración de fecha y hora
function configurar_fecha_hora {
    bash "$SCRIPT_DIR/date_time_zone/main.sh"
    if [ "$1" != "no_wait" ]; then
        read -p "Presione Enter para continuar..."
    fi
}

# Función para ejecutar el módulo de creación de particiones
function crear_particiones {
    bash "$SCRIPT_DIR/partitions/main.sh"
    if [ "$1" != "no_wait" ]; then
        read -p "Presione Enter para continuar..."
    fi
}

# Función para actualizar pacman
function pacman_update {
    bash "$SCRIPT_DIR/pacman_update/main.sh"
    if [ "$1" != "no_wait" ]; then
        read -p "Presione Enter para continuar..."
    fi
}

# Función para ejecutar el módulo de instalación de Arch Linux
function instalar_arch_linux {
    bash "$SCRIPT_DIR/install_arch/main.sh"
    if [ "$1" != "no_wait" ]; then
        read -p "Presione Enter para continuar..."
    fi
}

# Función para ejecutar el módulo de instalación usando Archinstall
function instalar_usando_archinstall {
    bash "$SCRIPT_DIR/install_by_archinstall/main.sh"
    if [ "$1" != "no_wait" ]; then
        read -p "Presione Enter para continuar..."
    fi
}

# Función para ejecutar el módulo de post-instalación de Arch Linux
function post_install_arch {
    bash "$SCRIPT_DIR/post_install/main.sh"
    if [ "$1" != "no_wait" ]; then
        read -p "Presione Enter para continuar..."
    fi
}

# Función para ejecutar todos los módulos en secuencia
function ejecutar_todos {
    ejecutar_de_corrido=true
    configurar_fecha_hora no_wait
    pacman_update no_wait
    crear_particiones no_wait
    instalar_arch_linux no_wait
    ejecutar_de_corrido=false
}

# Bucle principal del menú
while true; do
    show_menu
    case $opcion in
        "● Ejecucion de corrido")
            ejecutar_todos
            ;;
        "● Actualizar Pacman")
            pacman_update
            ;;
        "● Crear Particiones")
            crear_particiones
            ;;
        "● Instalar Arch Linux")
            instalar_arch_linux
            ;;
        "● Instalar usando Archinstall")
            instalar_usando_archinstall
            ;;
        "● Post-Instalación de Arch Linux")
            post_install_arch
            ;;
        "○ Salir")
            echo "Saliendo..."
            exit 0
            ;;
        *)
            echo "Opción inválida, intente nuevamente."
            sleep 2
            ;;
    esac
    read -p "Presione Enter para finalizar..."
done