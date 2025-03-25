#!/bin/bash
clear

# Colores Gameboy
HEX_DARK_GREEN="#0f380f"
HEX_GREEN="#306230"
HEX_LIGHT_GREEN="#8bac0f"
HEX_LIGHTEST_GREEN="#9bbc0f"

# Logo de Arch Linux
ARCH_LOGO="
           \e[38;2;15;56;15m.
          \e[38;2;15;56;15m/#\\
         \e[38;2;15;56;15m/###\\      \e[38;2;155;188;15m               #     \e[38;2;15;56;15m| *
        \e[38;2;15;56;15m/p^###\\     \e[38;2;155;188;15m a##e #%\" a#\"e 6##%  \e[38;2;15;56;15m| | |-^-. |   | \\ /
       \e[38;2;15;56;15m/##P^q##\\    \e[38;2;155;188;15m.oOo# #   #    #  #  \e[38;2;15;56;15m| | |   | |   |  X
      \e[38;2;15;56;15m/##(   )##\\   \e[38;2;155;188;15m%OoO# #   %#e\" #  #  \e[38;2;15;56;15m| | |   | ^._.| / \\ \e[38;2;139;172;15m TM
     \e[38;2;15;56;15m/###P   q#,^\\
    \e[38;2;15;56;15m/P^         ^q\\ \e[38;2;139;172;15m TM
"

# Función para mostrar el menú principal
function show_menu {
    clear
    gum style --border normal --margin "1" --padding "1" --border-foreground "$HEX_DARK_GREEN" --foreground "$HEX_LIGHTEST_GREEN" "$(echo -e "$ARCH_LOGO")"
    opcion=$(gum choose --cursor.foreground="$HEX_GREEN" --selected.foreground="$HEX_LIGHT_GREEN" \
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