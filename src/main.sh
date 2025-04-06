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
ARCH_LOGO+="${ARCH_BLUE}    ▟██████████▛        ▜█████████▙                    ${ARCH_WHITE}Menú ${ARCH_CYAN}Principal${ARCH_WHITE}:\n"
ARCH_LOGO+="${ARCH_BLUE}   ▟██████▀▀▀              ▀▀██████▙                   ===============\n"
ARCH_LOGO+="${ARCH_BLUE}  ▟███▀▘                       ▝▀███▙\n"
ARCH_LOGO+="${ARCH_BLUE} ▟▛▀                               ▀▜▙\n"
ARCH_LOGO+="${ARCH_RESET}"


# Función para mostrar el menú principal
function show_menu {
    clear
    echo -e "$ARCH_LOGO" | gum style --no-strip-ansi --border thick --margin "1" --padding "1" --border-foreground "$HEX_ARCH_CYAN" --foreground "$HEX_ARCH_WHITE" --bold
    opcion=$(gum choose --cursor.foreground="$HEX_ARCH_CYAN" --cursor.bold --selected.foreground="$HEX_ARCH_WHITE" --selected.bold --header="Seleccione:" --header.foreground="$HEX_ARCH_BLUE" --header.bold \
        "● Nueva Instalación" \
        "● Utilidades" \
        "○ Salir")
    
    case $opcion in
        "● Nueva Instalación")
            sh "$SCRIPT_DIR/modules/new_install/main.sh"
            ;;
        "● Utilidades")
            sh "$SCRIPT_DIR/modules/utilities/main.sh"
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
}

# Obtener el directorio del script
SCRIPT_DIR=$(dirname "$(realpath "$BASH_SOURCE")")

# Bucle principal del menú
while true; do
    show_menu
done