FROM archlinux:latest

# Agregar antes de instalar el kernel
RUN echo "KEYMAP=la-latin1" > /etc/vconsole.conf && \
    echo "FONT=" >> /etc/vconsole.conf

# O mejor aún, en un contenedor no necesitas initramfs:
RUN pacman -Syu --noconfirm --needed base base-devel

# Configurar systemd
ENV container docker
RUN pacman -Syu --noconfirm systemd \
    && ln -sf /usr/lib/systemd/systemd /sbin/init \
    && systemctl mask systemd-remount-fs.service

# Actualizar sistema e instalar paquetes básicos
RUN pacman -Syu --noconfirm --needed && \
    pacman -S --noconfirm --needed \
    linux \
    linux-firmware \
    dhcpcd \
    openssh \
    intel-ucode \
    sudo \
    git \
    vim \
    nano \
    wget \
    curl \
    zsh \
    htop \
    fastfetch \
    && pacman -Scc --noconfirm

# Configurar timezone
RUN ln -sf /usr/share/zoneinfo/UTC /etc/localtime

# Habilitar servicios necesarios (opcional)
RUN systemctl enable dhcpcd.service

# Configurar el punto de entrada para systemd
STOPSIGNAL SIGRTMIN+3
CMD ["/usr/lib/systemd/systemd"]

# As de desarrollo, instalar herramientas adicionales
RUN pacman -Syu --noconfirm opencode wl-clipboard xclip
RUN pacman -Syu --noconfirm uv python python-pip python-virtualenv github-cli gum npm

# CONFIGURAR HOSTNAME PERSONALIZADO
RUN echo "archlinux-dev" > /etc/hostname

# Autenticación automática en .zshrc
RUN echo '[ -n "$GH_TOKEN" ] && echo "$GH_TOKEN" | gh auth login --with-token &>/dev/null &' >> /root/.zshrc

# Crear .zshrc con fastfetch y prompt personalizado
RUN cat > /root/.zshrc << 'EOF'
# Fastfetch - Mostrar info del sistema al iniciar
if command -v fastfetch &> /dev/null; then
    if [[ $- == *i* ]]; then
        fastfetch
    fi
fi

# Prompt personalizado
PROMPT='%F{212}[%f%F{39}%n%f%F{212}@%f%F{93}%m%f%F{212}]%f %F{39}%1~%f %# '

EOF

WORKDIR /workspace
USER root

#docker build -t archlinux-systemd .
#docker run --privileged -it archlinux-systemd
#systemctl status