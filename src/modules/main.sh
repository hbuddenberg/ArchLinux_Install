#!/bin/bash
clear

# Colores Gameboy
DARK_GREEN="#0f380f"
GREEN="#306230"
LIGHT_GREEN="#8bac0f"
LIGHTEST_GREEN="#9bbc0f"

# Función para mostrar el menú principal
function show_menu {
    clear
    gum style --border normal --margin "1" --padding "1" --border-foreground "$DARK_GREEN" --foreground "$LIGHTEST_GREEN" "ArchHypr Install - Menú Principal"
    opcion=$(gum choose --cursor.foreground="$GREEN" --selected.foreground="$LIGHT_GREEN" --unselected.foreground="$LIGHTEST_GREEN" \
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
SCRIPT_DIR=$(dirname "${BASH_SOURCE[0]}")

# Bucle principal del menú
while true; do
    show_menu
done