#!/bin/bash
clear

# Colores Gameboy
HEX_DARK_GREEN="#0f380f"
HEX_GREEN="#306230"
HEX_LIGHT_GREEN="#8bac0f"
HEX_LIGHTEST_GREEN="#9bbc0f"

# Colores Gameboy
TTY_DARK_GREEN="\e[38;2;15;56;15m"
TTY_GREEN="\e[38;2;48;98;48m"
TTY_LIGHT_GREEN="\e[38;2;139;172;15m"
TTY_LIGHTEST_GREEN="\e[38;2;155;188;15m"
TTY_CLEAR="\e[H\e[2J"
TTY_RESET="\e[0m"

# Logo de Arch Linux
ARCH_LOGO="
$TTY_CLEAR
           $TTY_DARK_GREEN.
          $TTY_DARK_GREEN/#\\
         $TTY_DARK_GREEN/###\\      $TTY_LIGHTEST_GREEN               #     $TTY_DARK_GREEN| *
        $TTY_DARK_GREEN/p^###\\     $TTY_LIGHTEST_GREEN a##e #%\" a#\"e 6##%  $TTY_DARK_GREEN| | |-^-. |   | \\ /
       $TTY_DARK_GREEN/##P^q##\\    $TTY_LIGHTEST_GREEN.oOo# #   #    #  #  $TTY_DARK_GREEN| | |   | |   |  X
      $TTY_DARK_GREEN/##(   )##\\   $TTY_LIGHTEST_GREEN%OoO# #   %#e\" #  #  $TTY_DARK_GREEN| | |   | ^._.| / \\ $TTY_LIGHT_GREEN TM
     $TTY_DARK_GREEN/###P   q#,^\\
    $TTY_DARK_GREEN/P^         ^q\\ $TTY_LIGHT_GREEN TM
"

# Función para mostrar el menú principal
function show_menu {
    clear
    gum style --border normal --margin "1" --padding "1" --border-foreground "$HEX_DARK_GREEN" --foreground "$HEX_LIGHTEST_GREEN" "$ARCH_LOGO"
    gum style --border normal --margin "1" --padding "1" --border-foreground "$HEX_DARK_GREEN" --foreground "$HEX_LIGHTEST_GREEN" "ArchHypr Install - Menú Principal"
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