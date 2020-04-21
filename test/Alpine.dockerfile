FROM alpine:edge

RUN apk update && apk add \
    sudo \
    sed \
    curl

COPY ./test/chezmoi.toml ./test/entrypoint.sh /

RUN chmod +x /entrypoint.sh

# ENTRYPOINT [ "./entrypoint.sh" ]

CMD ["sh", "-c", "chezmoi apply --config /chezmoi.toml && fish"]
