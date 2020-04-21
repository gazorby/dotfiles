FROM ubuntu

RUN apt-get update && apt-get -y install \
    curl \
    git \
    sudo \
    sed \
    software-properties-common

RUN add-apt-repository ppa:fish-shell/release-3 && apt-get update && apt-get -y install fish

COPY ./test/chezmoi.toml ./test/entrypoint.sh /

RUN chmod +x /entrypoint.sh

ENTRYPOINT [ "./entrypoint.sh" ]

CMD ["chezmoi", "apply", "--config", "/chezmoi.toml"]
