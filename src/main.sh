#!/bin/bash
clear

# Verificar si gum está instalado
if ! command -v gum &> /dev/null; then
    echo "gum no está instalado. Instalando gum..."
    if command -v pacman &> /dev/null; then
        sudo pacman -S gum
    elif command -v apt-get &> /dev/null; then
        sudo apt-get install gum
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
ARCH_BLUE="\e[38;2;23;147;209m"
ARCH_WHITE="\e[1;37m"
ARCH_RESET="\e[0m"

# Logo de Arch Linux
ARCH_LOGO="\033[38;2;23;147;209m                   ▄
\033[38;2;23;147;209m                  ▟█▙
\033[38;2;23;147;209m                 ▟███▙
\033[38;2;23;147;209m                ▟█████▙
\033[38;2;23;147;209m               ▟███████▙
\033[38;2;23;147;209m              ▂▔▀▜██████▙
\033[38;2;23;147;209m             ▟██▅▂▝▜█████▙               
\033[38;2;23;147;209m            ▟█████████████▙              
\033[38;2;23;147;209m           ▟███████████████▙             
\033[38;2;23;147;209m          ▟█████████████████▙            \e[1;37m               #     \e[38;2;23;147;209m| *
\033[38;2;23;147;209m         ▟███████████████████▙           \e[1;37m a##e #%" a#"e 6##%  \e[38;2;23;147;209m| | |-^-. |   | \\ /
\033[38;2;23;147;209m        ▟█████████▛▀▀▜████████▙          \e[1;37m.oOo# #   #    #  #  \e[38;2;23;147;209m| | |   | |   |  X
\033[38;2;23;147;209m       ▟████████▛      ▜███████▙         \e[1;37m%OoO# #   %#e" #  #  \e[38;2;23;147;209m| | |   | ^._.| / \\
\033[38;2;23;147;209m      ▟█████████        ████████▙        
\033[38;2;23;147;209m     ▟██████████        █████▆▅▄▃▂       
\033[38;2;23;147;209m    ▟██████████▛        ▜█████████▙      
\033[38;2;23;147;209m   ▟██████▀▀▀              ▀▀██████▙     
\033[38;2;23;147;209m  ▟███▀▘                       ▝▀███▙    
\033[38;2;23;147;209m ▟▛▀                               ▀▜▙   \e[0m
"

# Función para mostrar el menú principal
function show_menu {
    clear
        gum style --border bold --margin "1" --padding "1" --border-foreground "$ARCH_BLUE" --foreground "$ARCH_WHITE" "echo -e $ARCH_LOGO"
    opcion=$(gum choose --cursor.foreground="$ARCH_BLUE" --selected.foreground="$ARCH_WHITE" \
        "1) Nueva Instalación" \
        "2) Utilidades" \
        "0) Salir")
    
    case $opcion in
        "1) Nueva Instalación")
            bash "$SCRIPT_DIR/new_install/main.sh"
            ;;
        "2) Utilidades")
            bash "$SCRIPT_DIR/utilities/main.sh"
            ;;
        "0) Salir")
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