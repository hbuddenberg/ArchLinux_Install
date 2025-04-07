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
        gum style --foreground 212 --bold "Generando lista de zonas horarias disponibles..."
        while true; do
            # Mostrar lista de zonas horarias directamente
            zona_horaria=$(timedatectl list-timezones | gum choose --header "Seleccione una zona horaria:")
            
            if [ -z "$zona_horaria" ]; then
                gum style --foreground 9 --bold "No se seleccionó ninguna zona horaria. Intente nuevamente."
                continue
            fi

            if timedatectl list-timezones | grep -q "^$zona_horaria$"; then
                gum style --foreground 10 --bold "Zona horaria seleccionada: $zona_horaria"
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

# Función para configurar la localización con confirmación inicial
function configurar_localizacion {
    if gum confirm "¿Desea usar la localización predeterminada 'es_CL.UTF-8 UTF-8'?" --affirmative "Sí" --negative "No"; then
        localizacion="es_CL.UTF-8 UTF-8"
    else
        listar_localizaciones
        while true; do
            localizacion=$(gum input --placeholder "Ingrese la localización:")
            if grep -q "^$localizacion$" /usr/share/i18n/SUPPORTED; then
                break
            else
                gum style --foreground 9 --bold "Localización no válida. Por favor, intente nuevamente."
            fi
        done
    fi

    gum style --foreground 212 --bold "Configurando localización a $localizacion..."
    sudo sed -i '/^[^#]/d' /etc/locale.gen
    echo "$localizacion" | sudo tee -a /etc/locale.gen
    sudo locale-gen
    echo "LANG=${localizacion%% *}" | sudo tee /etc/locale.conf
}

# Función para listar idiomas
function listar_idiomas {
    gum style --foreground 212 --bold "Listando idiomas disponibles..."
    localectl list-locales
}

# Función para configurar el idioma con confirmación inicial
function configurar_idioma {
    if gum confirm "¿Desea usar el idioma predeterminado 'es_CL.UTF-8'?" --affirmative "Sí" --negative "No"; then
        idioma="es_CL.UTF-8"
    else
        listar_idiomas
        while true; do
            idioma=$(gum input --placeholder "Ingrese el idioma:")
            if localectl list-locales | grep -q "^$idioma$"; then
                break
            else
                gum style --foreground 9 --bold "Idioma no válido. Por favor, intente nuevamente."
            fi
        done
    fi

    gum style --foreground 212 --bold "Configurando idioma a $idioma..."
    localectl set-locale LANG=$idioma
}

# Función para listar distribuciones de teclado
function listar_teclados {
    gum style --foreground 212 --bold "Listando distribuciones de teclado disponibles..."
    localectl list-keymaps
}

# Función para configurar el teclado con confirmación inicial
function configurar_teclado {
    if gum confirm "¿Desea usar la distribución de teclado predeterminada 'la-latin1'?" --affirmative "Sí" --negative "No"; then
        teclado="la-latin1"
    else
        listar_teclados
        while true; do
            teclado=$(gum input --placeholder "Ingrese la distribución del teclado:")
            if localectl list-keymaps | grep -q "^$teclado$"; then
                break
            else
                gum style --foreground 9 --bold "Distribución de teclado no válida. Por favor, intente nuevamente."
            fi
        done
    fi

    gum style --foreground 212 --bold "Configurando distribución del teclado a $teclado..."
    localectl set-keymap $teclado
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