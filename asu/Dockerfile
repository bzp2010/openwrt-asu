FROM quay.io/podman/stable:v5.8.0

RUN dnf -y install yq && dnf clean all

RUN curl -SL https://github.com/docker/compose/releases/latest/download/docker-compose-linux-x86_64 -o /usr/local/bin/docker-compose && \
  chmod +x /usr/local/bin/docker-compose

RUN git clone --depth 1 https://github.com/openwrt/asu

RUN mkdir -p /run/podman && chmod 777 /run/podman && chmod -R 777 /asu && \
  mkdir -p /tmp/images && mkdir -p /tmp/patches

USER podman

WORKDIR /asu

COPY ./images/* /tmp/images
COPY ./patches/* /tmp/patches
COPY ./asu/Dockerfile.asu /asu/Dockerfile.asu

COPY ./asu/entrypoint.sh /entrypoint.sh

EXPOSE 8000

VOLUME [ "/home/podman/.local/share/containers", "/asu/public" ]

ENTRYPOINT [ "/entrypoint.sh" ]
