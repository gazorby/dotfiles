FROM fedora

RUN dnf update -y && dnf install -y \
    git \
    curl \
    sudo \
    sed \
    findutils

RUN useradd -m -s /bin/bash -d /docker docker  \
&& echo "docker ALL=NOPASSWD: ALL" >> /etc/sudoers

COPY ./test/entrypoint.sh /docker/

RUN chmod +x /docker/entrypoint.sh

USER docker

RUN mkdir -p /docker/.config/chezmoi \
    && curl -sfL https://git.io/chezmoi | sudo sh \
    && /bin/chezmoi init https://github.com/Gazorby/dotfiles.git

COPY ./test/chezmoi.toml /docker/.config/chezmoi/

ENTRYPOINT [ "/docker/entrypoint.sh" ]

WORKDIR /docker

CMD ["sh", "-c", "chezmoi apply && fish"]
