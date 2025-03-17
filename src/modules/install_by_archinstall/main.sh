#!/bin/bash
clear

# Rutas por defecto
configuration="/tmp/ArchHypr_Install/src/configurations/user_configuration.json"
credentials="/tmp/ArchHypr_Install/src/configurations/user_credentials.json"

# Función para validar la existencia de los archivos
function validate_files {
    if [[ -f "$1" && -f "$2" ]]; then
        return 0
    else
        return 1
    fi
}

# Preguntar si se tienen archivos de configuración
read -p "¿Quieres usar archivos de configuración para archinstall? (s/n, por defecto 's'): " has_config

# Usar 'n' como valor por defecto
has_config=${has_config:-s}

if [[ "$has_config" == "s" || "$has_config" == "S" ]]; then
    while true; do
        read -p "Ingrese la ruta del archivo user_credentials.json (presione Enter para usar la ruta por defecto): " user_credentials_input
        read -p "Ingrese la ruta del archivo user_configuration.json (presione Enter para usar la ruta por defecto): " user_configuration_input

        # Usar rutas por defecto si no se ingresaron rutas
        user_credentials=${user_credentials_input:-$credentials}
        user_configuration=${user_configuration_input:-$configuration}

        # Validar archivos
        if validate_files "$user_credentials" "$user_configuration"; then
            echo "Archivos de configuración encontrados. Ejecutando archinstall..."
            pacman --noconfirm -Sy archinstall

            # Preguntar si se desea ejecutar en modo desatendido
            read -p "¿Deseas ejecutar archinstall en modo desatendido? (s/n, por defecto 's'): " unattended
            unattended=${unattended:-s}

            if [[ "$unattended" == "s" || "$unattended" == "S" ]]; then
                # El siguiente comando ejecuta archinstall en modo desatendido (sin intervención del usuario)
                archinstall --silent --config "$user_configuration" --creds "$user_credentials"
            else
                archinstall --config "$user_configuration" --creds "$user_credentials"
            fi
            break
        else
            echo "No se encontraron los archivos de configuración en las rutas especificadas. Inténtalo de nuevo."
        fi
    done
else
    echo "Ejecutando archinstall normalmente..."
    pacman --noconfirm -Sy archinstall
    archinstall
fi