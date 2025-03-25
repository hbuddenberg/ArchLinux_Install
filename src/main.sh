#!/bin/bash
clear

# Colores Gameboy
DARK_GREEN="\e[38;2;15;56;15m"
GREEN="\e[38;2;48;98;48m"
LIGHT_GREEN="\e[38;2;139;172;15m"
LIGHTEST_GREEN="\e[38;2;155;188;15m"
RESET="\e[0m"

# Logo de Arch Linux
ARCH_LOGO="
\e[H\e[2J
           \e[1;36m.
          \e[1;36m/#\\
         \e[1;36m/###\\      \e[1;37m               #     \e[1;36m| *
        \e[1;36m/p^###\\     \e[1;37m a##e #%\" a#\"e 6##%  \e[1;36m| | |-^-. |   | \\ /
       \e[1;36m/##P^q##\\    \e[1;37m.oOo# #   #    #  #  \e[1;36m| | |   | |   |  X
      \e[1;36m/##(   )##\\   \e[1;37m%OoO# #   %#e\" #  #  \e[1;36m| | |   | ^._.| / \\ \e[0;37mTM
     \e[1;36m/###P   q#,^\\
    \e[1;36m/P^         ^q\\ \e[0;37mTM
"

# Función para mostrar el menú principal
function show_menu {
    clear
    echo -e "$ARCH_LOGO"
    gum style --border normal --margin "1" --padding "1" --border-foreground "$DARK_GREEN" --foreground "$LIGHTEST_GREEN" "ArchHypr Install - Menú Principal"
    opcion=$(gum choose --cursor.foreground="$GREEN" --selected.foreground="$LIGHT_GREEN" \
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