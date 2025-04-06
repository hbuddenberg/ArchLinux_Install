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

# Listar discos disponibles usando gum
DISKS=$(lsblk -d -n -o NAME,SIZE | awk '{print $1 " (" $2 ")"}')

# Validar que se encontraron discos
if [[ -z "$DISKS" ]]; then
    gum style --foreground 196 "Error: No se encontraron discos disponibles."
    exit 1
fi

# Usar gum para seleccionar el disco
gum style --foreground 33 "Seleccione un disco de la lista:"
DISK_NAME=$(echo "$DISKS" | gum choose)
DISK_NAME=${DISK_NAME%% *} # Extraer solo el nombre del disco (ejemplo: sda)
DISK="/dev/$DISK_NAME"
BTRFS_PARTITION="${DISK}2"  # Asumiendo que la partición BTRFS es la 2 (ajustar según tu configuración)

# Verificar que el disco seleccionado existe
if [ ! -b "$DISK" ]; then
    echo "Error: El disco seleccionado no existe."
    exit 1
fi

# Detectar tamaño total del disco en GB
DISK_SIZE=$(lsblk -b -d -n -o SIZE "$DISK" | awk '{print $1 / 1024 / 1024 / 1024}')
DISK_SIZE=$(printf "%.0f" "$DISK_SIZE") # Redondear a entero

echo "El tamaño total del disco es: ${DISK_SIZE}GB"

# Ver información actual sobre el disco y particiones existentes
echo "Información de particiones actuales:"
lsblk -f "$DISK"

# Ver el espacio disponible en el disco
USED_SPACE=$(lsblk -b -n -o SIZE "$DISK" | awk '{sum+=$1} END {print sum/1024/1024/1024}')
FREE_SPACE=$(echo "$DISK_SIZE - $USED_SPACE" | bc)

echo "Espacio libre disponible en el disco: ${DISK_SIZE} GB"

# EFI fijo en 550MB (0.55GB)
EFI_SIZE=512
EFI_SIZE_GB=0.512

# Solicitar tamaños para cada partición, mostrando el espacio disponible
DEFAULT_ROOT_SIZE=$(echo "($DISK_SIZE - $EFI_SIZE_GB)" | bc)

read -p "Ingrese el tamaño de la partición / (GB) [${DEFAULT_ROOT_SIZE}]: " ROOT_SIZE
ROOT_SIZE=${ROOT_SIZE:-$DEFAULT_ROOT_SIZE}

# Preguntar si se desea una partición para máquinas virtuales (VM)
read -p "¿Desea crear una partición para máquinas virtuales? (s/n) [n]: " VM_OPTION
VM_OPTION=${VM_OPTION:-n}
if [[ "$VM_OPTION" == "s" ]]; then
    read -p "Ingrese el tamaño de la partición VM (GB): " VM_SIZE
else
    VM_SIZE=0
fi

# Calcular el espacio restante
TOTAL_USED=$(echo "$EFI_SIZE_GB + $ROOT_SIZE + $VM_SIZE" | bc)

# Verificar que las particiones no superen el tamaño del disco
if (( $(echo "$TOTAL_USED > $DISK_SIZE" | bc -l) )); then
    echo "Error: El tamaño total de las particiones ($TOTAL_USED GB) excede el tamaño del disco ($DISK_SIZE GB)."
    exit 1
fi

# Mostrar resumen
echo "Resumen de particiones:"
echo "EFI: ${EFI_SIZE}MB (Fijo)"
echo "/: ${ROOT_SIZE}GB (BTRFS)"
if [[ "$VM_OPTION" == "s" ]]; then
    echo "VM: ${VM_SIZE}GB (BTRFS)"
fi
echo "Total usado: ${TOTAL_USED}GB de ${DISK_SIZE}GB"

read -p "¿Desea continuar con la creación de particiones? (s/n) [s]: " CONFIRM
CONFIRM=${CONFIRM:-s}
if [[ $CONFIRM != "s" ]]; then
    echo "Operación cancelada."
    exit 1
fi

# Desmontar particiones previas
umount /mnt/var/cache /mnt/home /mnt/var/log /mnt/.snapshots /mnt/boot /mnt
umount ${DISK}* 2>/dev/null

# Eliminar particiones previas en /dev/sda (WARNING: BORRA TODO)
wipefs --force --all "$DISK"
sgdisk --zap-all "$DISK"
partprobe "$DISK"
sleep 2

# Crear nuevas particiones con gdisk
sgdisk -o "$DISK" # Crear tabla GPT
sgdisk -n 1:0:+${EFI_SIZE}M -t 1:EF00 -c 1:"EFI" "$DISK" # EFI
sgdisk -n 2:0:+${ROOT_SIZE}G -t 2:8304 -c 2:"/" "$DISK" # /

# Sincronizar cambios y refrescar particiones
partprobe "$DISK"
sleep 2

# Formatear las particiones
mkfs.fat -F32 "${DISK}1"  # EFI (FAT32)
mkfs.btrfs -f "${DISK}2"  # / (BTRFS)

if [[ "$VM_OPTION" == "s" && "$VM_SIZE" -gt 0 ]]; then
    mkfs.btrfs -f "${DISK}3"  # VM (BTRFS)
fi

echo "Particiones creadas y formateadas con éxito."

# Etiquetar particiones
fatlabel "${DISK}1" "EFI"
btrfs filesystem label "${DISK}2" "/"

if [[ "$VM_OPTION" == "s" && "$VM_SIZE" -gt 0 ]]; then
    btrfs filesystem label "${DISK}3" "VM"
fi

# Preguntar si se desea montar las particiones inmediatamente
read -p "¿Desea montar las particiones ahora? (s/n) [s]: " MOUNT_NOW
MOUNT_NOW=${MOUNT_NOW:-s}

if [[ $MOUNT_NOW == "s" ]]; then
    # Montaje y creación de subvolúmenes BTRFS
    echo "Montando y creando subvolúmenes..."

    # Validar si las particiones están montadas
    if mount | grep "${DISK}2" > /dev/null; then
        echo "La partición / ya está montada, desmontando..."
        umount "${DISK}2"
    fi
    if mount | grep "${DISK}1" > /dev/null; then
        echo "La partición EFI ya está montada, desmontando..."
        umount "${DISK}1"
    fi

    # Montar la partición BTRFS
    mount "${BTRFS_PARTITION}" /mnt

    # Crear subvolúmenes
    btrfs subvolume create /mnt/@
    btrfs subvolume create /mnt/@cache
    btrfs subvolume create /mnt/@home
    btrfs subvolume create /mnt/@snapshots
    btrfs subvolume create /mnt/@log
    umount /mnt

    # Montar el sistema raíz con opciones optimizadas
    mount -o compress=zstd:1,noatime,subvol=@ "${BTRFS_PARTITION}" /mnt
    mkdir -p /mnt/{boot/efi,home,.snapshots,var/{cache,log}}
    mount -o compress=zstd:1,noatime,subvol=@cache "${BTRFS_PARTITION}" /mnt/var/cache
    mount -o compress=zstd:1,noatime,subvol=@home "${BTRFS_PARTITION}" /mnt/home
    mount -o compress=zstd:1,noatime,subvol=@log "${BTRFS_PARTITION}" /mnt/var/log
    mount -o compress=zstd:1,noatime,subvol=@snapshots "${BTRFS_PARTITION}" /mnt/.snapshots
    mount /dev/sda1 /mnt/boot

    # Mostrar la tabla de particiones y nombres usando lsblk
    echo "Tabla de particiones actualizada:"
    lsblk -f "$DISK" -o NAME,FSTYPE,SIZE,FSSIZE,FSUSED,FSAVAIL,FSUSE%,PATH,MOUNTPOINTS,LABEL
else
    echo "Particiones creadas pero no montadas."
fi
