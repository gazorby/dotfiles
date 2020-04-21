FROM archlinux

RUN pacman -Syu --noconfirm && pacman -Scc --noconfirm && pacman -S --needed --noconfirm \
    curl \
    git \
    sudo \
    sed \
    fakeroot \
    binutils


RUN useradd -m -s /bin/bash -d /build build  \
&& echo "build ALL=NOPASSWD: ALL" >> /etc/sudoers

COPY ./test/chezmoi.toml ./test/entrypoint.sh /

RUN chmod +x /entrypoint.sh

USER build

ENTRYPOINT [ "./entrypoint.sh" ]
