#!/bin/bash

# Preguntar si se desea instalar to_dotfiles.sh en los ejecutables locales
read -p "¿Deseas instalar to_dotfiles en los ejecutables locales? (s/n): " instalar

if [[ "$instalar" == "s" || "$instalar" == "S" ]]; then
    # Definir la ruta de origen y destino
    origen="$(dirname "$0")/to_dotfiles"
    destino="/usr/local/bin/to_dotfiles"

    # Copiar el archivo a los ejecutables locales
    sudo cp "$origen" "$destino"

    # Otorgar los permisos necesarios
    sudo chmod +x "$destino"

    echo "to_dotfiles ha sido instalado en /usr/local/bin y se le han otorgado los permisos necesarios."
else
    echo "Instalación de to_dotfiles.sh cancelada."
fi