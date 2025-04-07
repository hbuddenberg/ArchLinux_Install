#!/bin/bash
clear

# Función para verificar si estamos en un entorno Live ISO
function is_live_iso {
    if grep -q "overlay" /etc/mtab; then
        return 0  # Está en un Live ISO
    else
        return 1  # No está en un Live ISO
    fi
}

# Verificar si gum está instalado
if ! command -v gum &> /dev/null; then
    echo "gum no está instalado. Intentando liberar espacio y luego instalar gum..."
    
    # Verificar si estamos en un entorno Live ISO
    if is_live_iso; then
        echo "Detectado entorno Live ISO. Liberando espacio automáticamente..."
        sudo rm -rf /var/cache/pacman/pkg/*
    else
        echo "No se detectó un entorno Live ISO. No se realizará la limpieza automática."
    fi

    # Intentar instalar gum
    if command -v pacman &> /dev/null; then
        echo "Instalando gum..."
        sudo pacman -S --noconfirm gum
    else
        echo "No se pudo instalar gum. Por favor, instálalo manualmente."
        exit 1
    fi
fi

# Usar gum para validar si el script está siendo ejecutado como superusuario
if [[ $EUID -ne 0 ]]; then
    gum style --foreground 212 "Este script requiere permisos de superusuario."
    if gum confirm "¿Quieres reiniciar el script con 'sudo'?" --affirmative "Sí" --negative "No"; then
        exec sudo bash "$0" "$@"
    else
        gum style --foreground 9 "No se puede continuar sin permisos de superusuario. Saliendo..."
        exit 1
    fi
fi

# Aquí continúa el resto del script...
gum style --foreground 10 "¡Permisos de superusuario detectados! Continuando con el script..."

clear 

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

# Función para configurar la zona horaria con confirmación inicial
function configurar_zona_horaria {
    if gum confirm "¿Desea usar la zona horaria predeterminada 'America/Santiago'?" --affirmative "Sí" --negative "No"; then
        zona_horaria="America/Santiago"
    else
        while true; do
            zona_horaria=$(gum input --placeholder "Ingrese la zona horaria ('mostrar' para ver todas)")
            if [ "$zona_horaria" == "mostrar" ]; then
                # Generar lista de zonas horarias y permitir selección con gum
                zona_horaria=$(timedatectl list-timezones | gum choose --no-limit --header "Seleccione una zona horaria:")
            fi

            if timedatectl list-timezones | grep -q "^$zona_horaria$"; then
                break
            else
                gum style --foreground 9 --bold "Zona horaria no válida. Por favor, intente nuevamente."
            fi
        done
    fi

    gum style --foreground 212 --bold "Configurando zona horaria a $zona_horaria..."
    timedatectl set-timezone "$zona_horaria"
    ln -sf /usr/share/zoneinfo/$zona_horaria /etc/localtime
    hwclock --systohc
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