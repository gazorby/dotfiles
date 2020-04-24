FROM alpine:edge

RUN apk update && apk add \
    git \
    sudo \
    sed \
    curl

RUN adduser -D -h /docker docker  \
&& echo "docker ALL=NOPASSWD: ALL" >> /etc/sudoers

COPY ./test/chezmoi.toml ./test/entrypoint.sh /docker/

RUN chmod +x /docker/entrypoint.sh

RUN mkdir /lib64 && ln -s /lib/libc.musl-x86_64.so.1 /lib64/ld-linux-x86-64.so.2

USER docker

ENTRYPOINT [ "/docker/entrypoint.sh" ]

CMD ["sh", "-c", "chezmoi apply --config ~/chezmoi.toml && fish"]
