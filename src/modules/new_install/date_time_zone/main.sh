#!/bin/bash
clear

# Verifica si el script se ejecuta como root
if [[ $EUID -ne 0 ]]; then
    echo "Este script debe ejecutarse como root"
    exit 1
fi

# Verifica si GUM está instalado, si no, lo instala
if ! command -v gum &> /dev/null; then
    echo "GUM no está instalado. Instalándolo ahora..."
    sudo pacman -Sy --noconfirm gum || { echo "Error al instalar GUM. Por favor, instálalo manualmente."; exit 1; }
fi

# Función para habilitar NTP
function habilitar_ntp {
    gum style --foreground 212 --bold "Habilitando NTP..."
    timedatectl set-ntp true
}

# Función para listar zonas horarias
function listar_zonas_horarias {
    gum style --foreground 212 --bold "Listando zonas horarias disponibles..."
    timedatectl list-timezones
}

# Función para configurar la zona horaria con selección interactiva
function configurar_zona_horaria {
    while true; do
        zona_horaria=$(gum input --placeholder "Ingrese la zona horaria (Enter para 'America/Santiago', 'mostrar' para ver todas)")
        zona_horaria=${zona_horaria:-America/Santiago}
        if [ "$zona_horaria" == "mostrar" ]; then
            # Generar lista de zonas horarias y permitir selección con gum
            zona_horaria=$(timedatectl list-timezones | gum choose --no-limit --header "Seleccione una zona horaria:")
        fi

        if timedatectl list-timezones | grep -q "^$zona_horaria$"; then
            gum style --foreground 212 --bold "Configurando zona horaria a $zona_horaria..."
            timedatectl set-timezone "$zona_horaria"
            ln -sf /usr/share/zoneinfo/$zona_horaria /etc/localtime
            hwclock --systohc
            break
        else
            gum style --foreground 9 --bold "Zona horaria no válida. Por favor, intente nuevamente."
        fi
    done
}

# Función para listar localizaciones
function listar_localizaciones {
    gum style --foreground 212 --bold "Listando localizaciones disponibles..."
    cat /usr/share/i18n/SUPPORTED
}

# Función para configurar la localización
function configurar_localizacion {
    while true; do
        localizacion=$(gum input --placeholder "Ingrese la localización (Enter para 'es_CL.UTF-8 UTF-8', 'mostrar' para ver todas)")
        localizacion=${localizacion:-es_CL.UTF-8 UTF-8}
        if [ "$localizacion" == "mostrar" ]; then
            listar_localizaciones
        elif grep -q "^$localizacion$" /usr/share/i18n/SUPPORTED; then
            gum style --foreground 212 --bold "Configurando localización a $localizacion..."
            sudo sed -i '/^[^#]/d' /etc/locale.gen
            echo "$localizacion" | sudo tee -a /etc/locale.gen
            sudo locale-gen
            echo "LANG=${localizacion%% *}" | sudo tee /etc/locale.conf
            break
        else
            gum style --foreground 9 --bold "Localización no válida. Por favor, intente nuevamente."
        fi
    done
}

# Función para listar idiomas
function listar_idiomas {
    gum style --foreground 212 --bold "Listando idiomas disponibles..."
    localectl list-locales
}

# Función para configurar el idioma
function configurar_idioma {
    while true; do
        idioma=$(gum input --placeholder "Ingrese el idioma (Enter para 'es_CL.UTF-8', 'mostrar' para ver todos)")
        idioma=${idioma:-es_CL.UTF-8}
        if [ "$idioma" == "mostrar" ]; then
            listar_idiomas
        elif localectl list-locales | grep -q "^$idioma$"; then
            gum style --foreground 212 --bold "Configurando idioma a $idioma..."
            localectl set-locale LANG=$idioma
            break
        else
            gum style --foreground 9 --bold "Idioma no válido. Por favor, intente nuevamente."
        fi
    done
}

# Función para listar distribuciones de teclado
function listar_teclados {
    gum style --foreground 212 --bold "Listando distribuciones de teclado disponibles..."
    localectl list-keymaps
}

# Función para configurar el teclado
function configurar_teclado {
    while true; do
        teclado=$(gum input --placeholder "Ingrese la distribución del teclado (Enter para 'la-latin1', 'mostrar' para ver todas)")
        teclado=${teclado:-la-latin1}
        if [ "$teclado" == "mostrar" ]; then
            listar_teclados
        elif localectl list-keymaps | grep -q "^$teclado$"; then
            gum style --foreground 212 --bold "Configurando distribución del teclado a $teclado..."
            localectl set-keymap $teclado
            break
        else
            gum style --foreground 9 --bold "Distribución de teclado no válida. Por favor, intente nuevamente."
        fi
    done
}

# Función para mostrar el estado actual
function mostrar_estado {
    gum style --foreground 212 --bold "Estado actual de la configuración de tiempo:"
    timedatectl status | grep -E "Local time|Universal time|Time zone"
    gum style --foreground 212 --bold "Estado actual de la configuración de localización, idioma y teclado:"
    localectl status
    gum style --foreground 212 --bold "Variables de entorno de localización:"
    env | grep -E '^(LANG|LANGUAGE|LC_)'
}

# Ejecutar secuencia
habilitar_ntp
configurar_zona_horaria
configurar_localizacion
configurar_idioma
configurar_teclado
mostrar_estado