FROM archlinux:latest

# Instalar paquetes necesarios
RUN pacman -Syu --noconfirm \
    && pacman -S --noconfirm base base-devel btrfs-progs linux linux-firmware dhcpcd openssh vim git intel-ucode gum \
    && pacman -Scc --noconfirm

# Configurar systemd
ENV container docker
RUN pacman -S --noconfirm systemd \
    && ln -sf /usr/lib/systemd/systemd /sbin/init \
    && systemctl mask systemd-remount-fs.service

# Habilitar servicios necesarios (opcional)
RUN systemctl enable dhcpcd.service

# Configurar el punto de entrada para systemd
STOPSIGNAL SIGRTMIN+3
CMD ["/usr/lib/systemd/systemd"]

#docker build -t archlinux-systemd .
#docker run --privileged -it archlinux-systemd
#systemctl status