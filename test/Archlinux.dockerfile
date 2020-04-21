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

USER build

COPY ./test/chezmoi.toml ./test/entrypoint.sh /build/

RUN sudo chmod +x /build/entrypoint.sh

ENTRYPOINT [ "/build/entrypoint.sh" ]

CMD ["sh", "-c", "chezmoi apply --config ~/chezmoi.toml && fish"]
