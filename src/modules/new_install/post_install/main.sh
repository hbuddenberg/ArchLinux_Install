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

################################################################

# Obtener la ruta del directorio del script actual de forma dinámica
if [ -z "$SCRIPT_DIR" ]; then
    SCRIPT_DIR=$(dirname "$(realpath "$BASH_SOURCE")")
fi

# Función para preguntar el nombre del hostname
function set_hostname() {
    gum style --foreground 10 "Introduce el nombre del hostname (por defecto: Nuc-Arch):"
    hostname=$(gum input)
    hostname=${hostname:-Nuc-Arch}
}

# Función para preguntar la contraseña del root
function ask_root_password() {
    gum style --foreground 10 "Introduce la contraseña del root:"
    root_password=$(gum input --password)
    if [[ -z "$root_password" ]]; then
        gum style --foreground 9 "Error: La contraseña del root no puede estar vacía."
        exit 1
    fi
}

# Función para preguntar el nombre del usuario
function set_username() {
    gum style --foreground 10 "Introduce el nombre del usuario:"
    username=$(gum input)
    if [[ -z "$username" ]]; then
        gum style --foreground 9 "Error: El nombre del usuario no puede estar vacío."
        exit 1
    fi
}

# Función para preguntar la contraseña del usuario
function ask_user_password() {
    gum style --foreground 10 "Introduce la contraseña del usuario $username:"
    user_password=$(gum input --password)
    if [[ -z "$user_password" ]]; then
        gum style --foreground 9 "Error: La contraseña del usuario no puede estar vacía."
        exit 1
    fi
}

# Función para preguntar si se desea ingresar un usuario
function ask_for_user_creation() {
    if gum confirm "¿Deseas crear un usuario adicional?" --affirmative "Sí" --negative "No"; then
        create_user="Sí"
    else
        create_user="No"
    fi

    echo "Creación de usuario: $create_user"
    if [[ "$create_user" == "Sí" ]]; then
        set_username
        ask_user_password
    fi
}

# Función para configurar el nombre del host
function configure_hostname() {
    echo "Configurando el nombre del host..."
    echo "$hostname" > /etc/hostname
}

# Función para configurar el archivo hosts
function configure_hosts_file() {
    gum style --foreground 10 "Configurando el archivo hosts..."
    cat <<EOT >> /etc/hosts
127.0.0.1   localhost
::1         localhost
127.0.1.1   $hostname.localdomain $hostname
EOT
}

# Función para instalar y configurar NetworkManager
function install_network_manager() {
    gum style --foreground 10 "Instalando y configurando NetworkManager..."
    pacman -S --noconfirm networkmanager wpa_supplicant
    systemctl enable NetworkManager
    systemctl start NetworkManager
    gum style --foreground 10 "NetworkManager configurado correctamente."
}

# Función para crear el script de configuración de WiFi
function create_wifi_script() {
    if gum confirm "¿Deseas conectarte a una red WiFi?" --affirmative "Sí" --negative "No"; then
        connect_wifi="Sí"
    else
        connect_wifi="No"
    fi

    if [[ "$connect_wifi" == "Sí" ]]; then
        gum style --foreground 10 "Introduce el nombre (SSID) de la red WiFi:"
        wifi_ssid=$(gum input)
        gum style --foreground 10 "Introduce la contraseña de la red WiFi ${wifi_ssid}:"
        wifi_pass=$(gum input --password)

        gum style --foreground 10 "Configurando conexión de red..."
        cat <<EOF > /usr/local/bin/wifi_config
#!/bin/bash

wifi_ssid="$wifi_ssid"
wifi_pass="$wifi_pass"

if command -v iwctl &> /dev/null; then
    iwctl --passphrase "\$wifi_pass" station wlan0 connect "\$wifi_ssid"
elif command -v nmcli &> /dev/null; then
    nmcli device wifi connect "\$wifi_ssid" password "\$wifi_pass"
else
    gum style --foreground 9 "No se encontraron herramientas para conectar a WiFi."
    exit 1
fi
EOF

        chmod +x /usr/local/bin/wifi_config
        /usr/local/bin/wifi_config
        gum style --foreground 10 "Conexión WiFi configurada correctamente."
    fi
}

# Función para configurar systemd-boot
function configure_systemd_boot() {
    gum style --foreground 10 "Instalando y configurando systemd-boot..."
    bootctl install
}

# Función para crear el directorio de entradas del bootloader
function create_bootloader_entries() {
    gum style --foreground 10 "Creando el directorio de entradas del bootloader..."
    mkdir -p /boot/loader/entries
}

# Función para configurar el loader
function configure_loader() {
    gum style --foreground 10 "Configurando el loader..."
    cat <<EOT > /boot/loader/loader.conf
default arch
#timeout 3
#editor  0
#console-mode max
#console-mode keep
EOT
}

# Función para crear la entrada de i915 para Boot Splash
function create_i915_entry() {
    gum style --foreground 10 "Creando la entrada de i915 para Boot Splash..."
    tee /etc/modprobe.d/i915.conf > /dev/null <<EOF
options i915 fastboot=1
options i915 enable_guc=2
options i915 enable_fbc=1
EOF
}

# Función para crear la entrada de arranque predeterminada
function create_default_boot_entry() {
    gum style --foreground 10 "Creando la entrada de arranque predeterminada..."
    cat <<EOT > /boot/loader/entries/arch.conf
title   Arch Linux
linux   /vmlinuz-linux
initrd  /intel-ucode.img
initrd  /initramfs-linux.img
options root=/dev/sda2 rw rootfstype=btrfs quiet loglevel=3 systemd.show_status=auto rd.udev.log_level=3 rootflags=subvol=/@
EOT
}

# Función para crear la entrada de arranque de fallback
function create_fallback_boot_entry() {
    gum style --foreground 10 "Creando la entrada de arranque de fallback..."
    cat <<EOT > /boot/loader/entries/arch-fallback.conf
title   Arch Linux (Fallback)
linux   /vmlinuz-linux
initrd  /intel-ucode.img
initrd  /initramfs-linux-fallback.img
options root=/dev/sda2 rw rootfstype=btrfs rootflags=subvol=/@
EOT
}

# Función para modificar mkinitcpio.conf
function modify_mkinitcpio_conf() {
    gum style --foreground 10 "Initramfs: Modificando /etc/mkinitcpio.conf para agregar el hook btrfs..."
    sed -i 's/HOOKS=(\(.*\) block \(.*\) filesystem \(.*\))/HOOKS=(\1 block btrfs \2 filesystem \3)/' /etc/mkinitcpio.conf
    mkinitcpio -p linux
}

# Función para generar la imagen initramfs
function generate_initramfs() {
    gum style --foreground 10 "Generando la imagen initramfs..."
    mkinitcpio -P
    if [ $? -ne 0 ]; then
        gum style --foreground 9 "Error: La generación de la imagen initramfs falló."
        exit 1
    fi
}

# Función para establecer la contraseña de root
function set_root_password() {
    gum style --foreground 10 "Estableciendo la contraseña de root..."
    echo "root:$root_password" | chpasswd
    if [ $? -ne 0 ]; then
        gum style --foreground 9 "Error: No se pudo cambiar la contraseña de root."
        exit 1
    fi
}

# Función para crear el usuario
function create_user() {
    if [[ -n "$username" ]]; then
        gum style --foreground 10 "Creando el usuario $username..."
        useradd -m -G wheel -s /bin/bash "$username"
        gum style --foreground 10 "Estableciendo la contraseña para el usuario $username..."
        echo "$username:$user_password" | chpasswd
        if [ $? -ne 0 ]; then
            gum style --foreground 9 "Error: No se pudo cambiar la contraseña del usuario $username."
            exit 1
        fi
    else
        gum style --foreground 9 "No se creó ningún usuario."
    fi
}

# Función para configurar permisos de sudo para el grupo wheel
function configure_sudoers() {
    gum style --foreground 10 "Configurando permisos de sudo para el grupo wheel..."
    sed -i 's/^# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/' /etc/sudoers
}

# Función para habilitar el servicio SSH
function enable_ssh() {
    gum style --foreground 10 "Habilitando el servicio SSH..."
    systemctl enable sshd
}

# Función para actualizar los directorios de usuario
function update_user_dirs() {
    gum style --foreground 10 "Actualizando los directorios de usuario..."
    pacman -S --noconfirm xdg-user-dirs
    sudo -u $username xdg-user-dirs-update
}

# Función para enmascarar el dispositivo TPM
function mask_tpm_device() {
    gum style --foreground 10 "Enmascarando el dispositivo TPM..."
    systemctl mask dev-tpmrm0.device
}

# Función para configurar auto login en tty1
function configure_auto_login() {
    if gum confirm "¿Deseas configurar auto login en tty1?" --affirmative "Sí" --negative "No"; then
        gum style --foreground 10 "Selecciona el usuario para auto login (por defecto: $username):"
        auto_login_user=$(gum choose "$username" "root" )
        auto_login_user=${auto_login_user:-$username}

        if [[ -z "$auto_login_user" ]]; then
            gum style --foreground 9 "No se seleccionó ningún usuario. Saliendo..."
            exit 1
        fi

        mkdir -p /etc/systemd/system/getty@tty1.service.d
        echo -e "[Service]\nExecStart=\nExecStart=-/usr/bin/agetty --autologin $auto_login_user --noclear %I \$TERM" | tee /etc/systemd/system/getty@tty1.service.d/override.conf
        systemctl daemon-reload
        systemctl restart getty@tty1
    fi
}

# Función para habilitar las cuotas de Btrfs
function enable_btrfs_quotas() {
    gum style --foreground 10 "Habilitando cuotas de Btrfs..."
    btrfs quota enable /
    if [ $? -ne 0 ]; then
        gum style --foreground 9 "Error: No se pudieron habilitar las cuotas de Btrfs."
        exit 1
    fi
    gum style --foreground 10 "Cuotas de Btrfs habilitadas correctamente."
}

# Función para instalar Timeshift y crear una copia de seguridad
function install_timeshift() {
    if gum confirm "¿Deseas crear una copia de seguridad con Timeshift ahora?" --affirmative "Sí" --negative "No"; then
        pacman -S --noconfirm timeshift
        enable_btrfs_quotas
        gum style --foreground 10 "Generando la primera copia de seguridad con Timeshift..."
        timeshift --create --comments "Primera copia de seguridad" --tags D
    fi
}

# Función para ejecutar scripts adicionales
function run_additional_scripts() {
    gum style --foreground 10 "Ejecutando scripts adicionales..."
    chmod +x /tmp/ArchLinux_Install/src/modules/new_install/date_time_zone/main.sh
    chmod +x /tmp/ArchLinux_Install/src/modules/new_install/pacman_update/main.sh

    gum style --foreground 10 "Ejecutando script de configuración de fecha, hora y zona horaria..."
    sudo  -u $username sh /tmp/ArchLinux_Install/src/modules/new_install/date_time_zone/main.sh

    gum style --foreground 10 "Ejecutando script de actualización de Pacman..."
    sudo -u $username sh /tmp/ArchLinux_Install/src/modules/new_install/pacman_update/main.sh

    gum style --foreground 10 "Scripts adicionales ejecutados correctamente."
}

# Función principal
function main() {
    gum style --foreground 10 "Iniciando el proceso de configuración del sistema..."

    set_hostname
    ask_root_password
    ask_for_user_creation

    gum style --foreground 10 "Configurando el sistema..."
    configure_hostname
    configure_hosts_file
    install_network_manager
    create_wifi_script
    configure_systemd_boot
    create_bootloader_entries
    configure_loader
    create_i915_entry
    create_default_boot_entry
    create_fallback_boot_entry
    modify_mkinitcpio_conf
    generate_initramfs
    set_root_password
    create_user
    configure_sudoers
    enable_ssh
    update_user_dirs
    mask_tpm_device
    configure_auto_login

    gum style --foreground 10 "Ejecutando scripts adicionales..."
    run_additional_scripts

    gum style --foreground 10 "Instalando y configurando Timeshift..."
    install_timeshift

    gum style --foreground 10 "Saliendo del chroot..."
    echo "Configuración completada."
}

# Ejecutar la función principal
main