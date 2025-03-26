FROM archlinux:latest

RUN pacman -Syu --noconfirm \
    && pacman -S --noconfirm base base-devel btrfs-progs linux linux-firmware dhcpcd openssh vim git intel-ucode\
    && pacman -S --noconfirm git gum \
    && pacman -Scc --noconfirm

CMD ["/bin/bash"]