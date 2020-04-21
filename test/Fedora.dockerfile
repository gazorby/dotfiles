FROM fedora

RUN dnf update -y && dnf install -y \
    git \
    curl \
    sudo \
    sed

COPY ./test/chezmoi.toml ./test/entrypoint.sh /

RUN chmod +x /entrypoint.sh

ENTRYPOINT [ "./entrypoint.sh" ]

CMD ["sh", "-c", "chezmoi apply --config /chezmoi.toml && fish"]
