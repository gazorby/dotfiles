FROM archlinux

RUN pacman -Syu --noconfirm && pacman -Scc --noconfirm && pacman -S --needed --noconfirm \
    curl \
    git \
    sudo \
    sed \
    fakeroot \
    binutils

RUN useradd -m -s /bin/bash -d /docker docker  \
&& echo "docker ALL=NOPASSWD: ALL" >> /etc/sudoers

COPY ./test/chezmoi.toml ./test/entrypoint.sh /docker/

RUN chmod +x /docker/entrypoint.sh

USER docker

ENTRYPOINT [ "/docker/entrypoint.sh" ]

CMD ["sh", "-c", "chezmoi apply --config ~/chezmoi.toml && fish"]
