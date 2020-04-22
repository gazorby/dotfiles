FROM ubuntu

RUN apt-get update && apt-get -y install \
    curl \
    git \
    sudo \
    sed \
    software-properties-common

RUN add-apt-repository ppa:fish-shell/release-3 && apt-get update && apt-get -y install fish

RUN useradd -m -s /bin/bash -d /docker docker  \
&& echo "docker ALL=NOPASSWD: ALL" >> /etc/sudoers

COPY ./test/chezmoi.toml ./test/entrypoint.sh /docker/

RUN chmod +x /docker/entrypoint.sh

USER docker

ENTRYPOINT [ "/docker/entrypoint.sh" ]

CMD ["sh", "-c", "chezmoi apply --config ~/chezmoi.toml && fish"]
