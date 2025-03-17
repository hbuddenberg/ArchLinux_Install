#!/bin/bash
clear
# Verifica si el script se ejecuta como root
if [[ $EUID -ne 0 ]]; then
    echo "Este script debe ejecutarse como root" 
    exit 1
fi

################################################################

# Obtener la ruta del directorio del script actual
SCRIPT_DIR=$(dirname "${BASH_SOURCE[0]}")

# Función para preguntar el nombre del hostname
function set_hostname() {
    read -p "Introduce el nombre del hostname [Nuc-Arch]: " hostname
    hostname=${hostname:-Nuc-Arch}
}

# Función para preguntar la contraseña del root
function ask_root_password() {
    read -sp "Introduce la contraseña del root: " root_password
    echo
}

# Función para preguntar el nombre del usuario
function set_username() {
    read -p "Introduce el nombre del usuario: " username
}

# Función para preguntar la contraseña del usuario
function ask_user_password() {
    read -sp "Introduce la contraseña del usuario $username: " user_password
    echo
}

# Función para preguntar si se desea ingresar un usuario
function ask_for_user_creation() {
    read -p "¿Deseas crear un nuevo usuario? (s/n) [s]: " create_user
    create_user=${create_user:-s}
    if [[ "$create_user" == "s" || "$create_user" == "S" ]]; then
        set_username
        if [[ -z "$username" ]]; then
            echo "Error: El nombre de usuario no puede estar vacío."
            exit 1
        fi
        ask_user_password
    fi
}

# Función para configurar el nombre del host
function configure_hostname() {
    echo "Configurando el nombre del host..."
    echo "$hostname" > /etc/hostname
    echo "---------------------------------------------------"
}

# Función para configurar el archivo hosts
function configure_hosts_file() {
    echo "Configurando el archivo hosts..."
    cat <<EOT >> /etc/hosts
127.0.0.1   localhost
::1         localhost
127.0.1.1   $hostname.localdomain $hostname
EOT
    echo "---------------------------------------------------"
}

# Función para instalar y configurar NetworkManager
function install_network_manager() {
    echo "Instalando y configurando NetworkManager..."
    pacman -S --noconfirm networkmanager wpa_supplicant
    systemctl enable NetworkManager
    systemctl start NetworkManager2
    echo "---------------------------------------------------"
}

# Función para crear el script de configuración de WiFi
function create_wifi_script() {
    # Verificar si se desea conectar a WiFi
    read -p "¿Deseas conectarte a una red WiFi? (s/n) [s]: " connect_wifi
    connect_wifi=${connect_wifi:-s}
    if [[ "$connect_wifi" == "s" || "$connect_wifi" == "S" ]]; then
        # Solicitar SSID y contraseña
        read -p "Introduce el nombre (SSID) de la red WiFi: " wifi_ssid
        read -sp "Introduce la contraseña de la red WiFi: " wifi_pass
        echo

        echo "Configurando conexión de red..."
        cat <<EOF > /usr/local/bin/wifi_config.sh
#!/bin/bash

wifi_ssid="$wifi_ssid"
wifi_pass="$wifi_pass"

# Verificar qué herramienta está disponible
if command -v iwctl &> /dev/null; then
    echo "Conectando usando iwctl..."
    iwctl --passphrase "\$wifi_pass" station wlan0 connect "\$wifi_ssid"
elif command -v nmcli &> /dev/null; then
    echo "Conectando usando nmcli..."
    nmcli device wifi connect "\$wifi_ssid" password "\$wifi_pass"
else
    echo "No se encontraron herramientas para conectar a WiFi (iwctl o nmcli)."
    echo "Instalando iwd para usar networkmanager..."
    pacman -S --noconfirm networkmanager
    systemctl enable NetworkManager
    echo "Conectando usando networkmanager..."
    nmcli device wifi connect "\$wifi_ssid" password "\$wifi_pass"
fi

echo "Reiniciando servicios de red..."
systemctl restart systemd-networkd
echo "Conexión WiFi configurada."
EOF

        chmod +x /usr/local/bin/configurar_wifi.sh
        /usr/local/bin/configurar_wifi.sh
        echo "---------------------------------------------------"
    fi
}

# Función para configurar systemd-boot
function configure_systemd_boot() {
    echo "Instalando y configurando systemd-boot..."
    bootctl install
    echo "---------------------------------------------------"
}

# Función para crear el directorio de entradas del bootloader
function create_bootloader_entries() {
    echo "Creando el directorio de entradas del bootloader..."
    mkdir -p /boot/loader/entries
    echo "---------------------------------------------------"
}

# Función para configurar el loader
function configure_loader() {
    echo "Configurando el loader..."
    cat <<EOT > /boot/loader/loader.conf
default arch
#timeout 3
#editor  0
#console-mode max
#console-mode keep
EOT
    echo "---------------------------------------------------"
}

# Función para crear la entrada de i915 para Boot Splash
function create_i915_entry() {
    echo "Creando la entrada de i915 para Boot Splash..."
    tee /etc/modprobe.d/i915.conf > /dev/null <<EOF
options i915 fastboot=1
options i915 enable_guc=2
options i915 enable_fbc=1
EOF
    echo "---------------------------------------------------"
}

# Función para crear la entrada de arranque predeterminada
function create_default_boot_entry() {
    echo "Creando la entrada de arranque predeterminada..."
    cat <<EOT > /boot/loader/entries/arch.conf
title   Arch Linux
linux   /vmlinuz-linux
initrd  /intel-ucode.img
initrd  /initramfs-linux.img
options root=/dev/sda2 rw rootfstype=btrfs quiet loglevel=3 systemd.show_status=auto rd.udev.log_level=3 rootflags=subvol=/@
EOT
    echo "---------------------------------------------------"
}

# Función para crear la entrada de arranque de fallback
function create_fallback_boot_entry() {
    echo "Creando la entrada de arranque de fallback..."
    cat <<EOT > /boot/loader/entries/arch-fallback.conf
title   Arch Linux (Fallback)
linux   /vmlinuz-linux
initrd  /intel-ucode.img
initrd  /initramfs-linux-fallback.img
options root=/dev/sda2 rw rootfstype=btrfs rootflags=subvol=/@
EOT
    echo "---------------------------------------------------"
}

# Función para modificar mkinitcpio.conf
function modify_mkinitcpio_conf() {
    echo "Initramfs: Modificando /etc/mkinitcpio.conf para agregar el hook btrfs..."
    sed -i 's/HOOKS=(\(.*\) block \(.*\) filesystem \(.*\))/HOOKS=(\1 block btrfs \2 filesystem \3)/' /etc/mkinitcpio.conf
    mkinitcpio -p linux
    echo "---------------------------------------------------"
}

# Función para generar la imagen initramfs
function generate_initramfs() {
    echo "Generando la imagen initramfs..."
    mkinitcpio -P
    if [ $? -ne 0 ]; then
        echo "Error: La generación de la imagen initramfs falló."
        exit 1
    fi
    echo "---------------------------------------------------"
}

# Función para establecer la contraseña de root
function set_root_password() {
    echo "Estableciendo la contraseña de root..."
    echo "root:$root_password" | chpasswd
    if [ $? -ne 0 ]; then
        echo "Error: No se pudo cambiar la contraseña de root."
        exit 1
    fi
    echo "---------------------------------------------------"
}

# Función para crear el usuario
function create_user() {
    if [[ -n "$username" ]]; then
        echo "Creando el usuario $username..."
        useradd -m -G wheel -s /bin/bash "$username"
        echo "Estableciendo la contraseña para el usuario $username..."
        echo "$username:$user_password" | chpasswd
        if [ $? -ne 0 ]; then
            echo "Error: No se pudo cambiar la contraseña del usuario $username."
            exit 1
        fi
        echo "---------------------------------------------------"
    else
        echo "No se creó ningún usuario."
    fi
}

# Función para configurar permisos de sudo para el grupo wheel
function configure_sudoers() {
    echo "Configurando permisos de sudo para el grupo wheel..."
    sed -i 's/^# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/' /etc/sudoers
    echo "---------------------------------------------------"
}

# Función para habilitar el servicio SSH
function enable_ssh() {
    echo "Habilitando el servicio SSH..."
    systemctl enable sshd
    echo "---------------------------------------------------"
}

# Función para actualizar los directorios de usuario
function update_user_dirs() {
    echo "Actualizando los directorios de usuario..."
    pacman -S --noconfirm xdg-user-dirs
    sudo -u $username xdg-user-dirs-update
    echo "---------------------------------------------------"
}

# Función para enmascarar el dispositivo TPM
function mask_tpm_device() {
    echo "Enmascarando el dispositivo TPM..."
    systemctl mask dev-tpmrm0.device
    echo "---------------------------------------------------"
}

# Función para configurar auto login en tty1
function configure_auto_login() {
    echo "Configurando auto login para root o el usuario creado en tty1..."
    read -p "¿Deseas configurar auto login en tty1? (s/n) [n]: " auto_login
    auto_login=${auto_login:-n}
    if [[ "$auto_login" == "s" || "$auto_login" == "S" ]]; then
        echo "Usuarios disponibles:"
        echo "1) root"
        echo "2) $username"

        read -p "Introduce el número del usuario para auto login: " user_number
        if [[ "$user_number" == "1" ]]; then
            auto_login_user="root"
        elif [[ "$user_number" == "2" ]]; then
            auto_login_user="$username"
        else
            echo "Número de usuario no válido."
            exit 1
        fi

        mkdir -p /etc/systemd/system/getty@tty1.service.d
        echo -e "[Service]\nExecStart=\nExecStart=-/usr/bin/agetty --autologin $auto_login_user --noclear %I \$TERM" | tee /etc/systemd/system/getty@tty1.service.d/override.conf
        systemctl daemon-reload
        systemctl restart getty@tty1
    fi
    echo "---------------------------------------------------"
}

# Función para habilitar las cuotas de Btrfs
function enable_btrfs_quotas() {
    echo "Habilitando cuotas de Btrfs..."
    btrfs quota enable /
    if [ $? -ne 0 ]; then
        echo "Error: No se pudieron habilitar las cuotas de Btrfs."
        exit 1
    fi
    echo "---------------------------------------------------"
}

# Función para instalar Timeshift y crear una copia de seguridad
function install_timeshift() {
    echo "Instalando Timeshift..."
    read -p "¿Deseas crear una copia de seguridad con Timeshift ahora? (s/n): " create_backup
    if [[ "$create_backup" == "s" || "$create_backup" == "S" ]]; then
        pacman -S --noconfirm timeshift
        enable_btrfs_quotas
        echo "Generando la primera copia de seguridad con Timeshift..."
        timeshift --create --comments "Primera copia de seguridad" --tags D
        echo "---------------------------------------------------"
    fi
}

# Función para ejecutar scripts adicionales
function run_additional_scripts() {
    echo "Ejecutando scripts adicionales..."
    chmod +x /tmp/ArchHypr_Install/src/modules/date_time_zone/main.sh
    chmod +x /tmp/ArchHypr_Install/src/modules/pacman_update/main.sh
    sudo -u $username /tmp/ArchHypr_Install/src/modules/date_time_zone/main.sh
    sudo -u $username /tmp/ArchHypr_Install/src/modules/pacman_update/main.sh
    echo "---------------------------------------------------"
}

# Función principal
function main() {
    set_hostname
    ask_root_password
    ask_for_user_creation

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

    # Ejecutar los scripts adicionales antes de timeshift
    run_additional_scripts

    install_timeshift
    
    echo "Saliendo del chroot..."
}

# Ejecutar la función principal
main