#!/bin/bash
clear
# Verifica si el script se ejecuta como root
if [[ $EUID -ne 0 ]]; then
    echo "Este script debe ejecutarse como root" 
    exit 1
fi

# Script principal que ejecuta la secuencia y selecciona el módulo a ejecutar.

function habilitar_ntp {
    echo "Habilitando NTP..."
    timedatectl set-ntp true
}

function listar_zonas_horarias {
    echo "Listando zonas horarias disponibles..."
    timedatectl list-timezones
}

function configurar_zona_horaria {
    while true; do
        read -p "Ingrese la zona horaria que desea configurar (presione Enter para 'America/Santiago' o escriba 'mostrar' para ver todas las zonas horarias): " zona_horaria
        zona_horaria=${zona_horaria:-America/Santiago}
        if [ "$zona_horaria" == "mostrar" ]; then
            listar_zonas_horarias
        elif timedatectl list-timezones | grep -q "^$zona_horaria$"; then
            echo "Configurando zona horaria a $zona_horaria..."
            timedatectl set-timezone "$zona_horaria"
            ln -sf /usr/share/zoneinfo/$zona_horaria /etc/localtime
            hwclock --systohc
            break
        else
            echo "Zona horaria no válida. Por favor, intente nuevamente."
        fi
    done
}

function listar_localizaciones {
    echo "Listando localizaciones disponibles..."
    cat /usr/share/i18n/SUPPORTED
}

function configurar_localizacion {
    while true; do
        read -p "Ingrese la localización (presione Enter para 'es_CL.UTF-8 UTF-8' o escriba 'mostrar' para ver todas las localizaciones): " localizacion
        localizacion=${localizacion:-es_CL.UTF-8 UTF-8}
        if [ "$localizacion" == "mostrar" ]; then
            listar_localizaciones
        elif grep -q "^$localizacion$" /usr/share/i18n/SUPPORTED; then
            echo "Configurando localización a $localizacion..."
            # Eliminar líneas no comentadas previamente en /etc/locale.gen
            sudo sed -i '/^[^#]/d' /etc/locale.gen
            echo "$localizacion" | sudo tee -a /etc/locale.gen
            sudo locale-gen
            echo "LANG=${localizacion%% *}" | sudo tee /etc/locale.conf
            break
        else
            echo "Localización no válida. Por favor, intente nuevamente."
        fi
    done
}

function listar_idiomas {
    echo "Listando idiomas disponibles..."
    localectl list-locales
}

function configurar_idioma {
    while true; do
        read -p "Ingrese el idioma (presione Enter para 'es_CL.UTF-8' o escriba 'mostrar' para ver todos los idiomas): " idioma
        idioma=${idioma:-es_CL.UTF-8}
        if [ "$idioma" == "mostrar" ]; then
            listar_idiomas
        elif localectl list-locales | grep -q "^$idioma$"; then
            echo "Configurando idioma a $idioma..."
            localectl set-locale LANG=$idioma
            break
        else
            echo "Idioma no válido. Por favor, intente nuevamente."
        fi
    done
}

function listar_teclados {
    echo "Listando distribuciones de teclado disponibles..."
    localectl list-keymaps
}

function configurar_teclado {
    while true; do
        read -p "Ingrese la distribución del teclado (presione Enter para 'la-latin1' o escriba 'mostrar' para ver todas las distribuciones de teclado): " teclado
        teclado=${teclado:-la-latin1}
        if [ "$teclado" == "mostrar" ]; then
            listar_teclados
        elif localectl list-keymaps | grep -q "^$teclado$"; then
            echo "Configurando distribución del teclado a $teclado..."
            localectl set-keymap $teclado
            break
        else
            echo "Distribución de teclado no válida. Por favor, intente nuevamente."
        fi
    done
}

function configurar_variables_locale {
    echo "Configurando variables de entorno de localización..."

    # Obtener el locale actual o usar es_CL.UTF-8 por defecto
    local locale_actual=$(localectl status | grep "System Locale" | cut -d= -f2 | tr -d '"' | tr -d ' ')
    locale_actual=${locale_actual:-es_CL.UTF-8}

    # Verificar si el locale está generado, si no, generarlo
    if ! grep -q "^$locale_actual" /usr/share/i18n/SUPPORTED; then
        echo "Generando locale $locale_actual..."
        sudo sed -i "/^#$locale_actual/s/^#//" /etc/locale.gen
        sudo locale-gen
    fi

    # Crear o actualizar el archivo /etc/environment
    echo "Actualizando /etc/environment..."
    sudo tee /etc/environment > /dev/null << EOF
LANG=$locale_actual
LANGUAGE=$locale_actual
LC_ALL=$locale_actual
LC_CTYPE=$locale_actual
LC_NUMERIC=$locale_actual
LC_TIME=$locale_actual
LC_COLLATE=$locale_actual
LC_MONETARY=$locale_actual
LC_MESSAGES=$locale_actual
LC_PAPER=$locale_actual
LC_NAME=$locale_actual
LC_ADDRESS=$locale_actual
LC_TELEPHONE=$locale_actual
LC_MEASUREMENT=$locale_actual
LC_IDENTIFICATION=$locale_actual
EOF

    # Actualizar /etc/default/locale si existe
    if [ -d "/etc/default" ]; then
        echo "Actualizando /etc/default/locale..."
        sudo tee /etc/default/locale > /dev/null << EOF
LANG=$locale_actual
LANGUAGE=$locale_actual
LC_ALL=$locale_actual
EOF
    fi

    # Exportar variables para la sesión actual
    export LANG=$locale_actual
    export LANGUAGE=$locale_actual
    export LC_ALL=$locale_actual

    echo "Variables de localización configuradas correctamente."
}

function mostrar_estado {
    echo "Estado actual de la configuración de tiempo:"
    timedatectl status | grep -E "Local time|Universal time|Time zone"
    echo "Estado actual de la configuración de localización, idioma y teclado:"
    localectl status
    echo "Variables de entorno de localización:"
    env | grep -E '^(LANG|LANGUAGE|LC_)'
}

# Ejecutar secuencia
habilitar_ntp
configurar_zona_horaria
configurar_localizacion
configurar_idioma
configurar_teclado
configurar_variables_locale
mostrar_estado