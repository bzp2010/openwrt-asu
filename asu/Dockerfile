FROM quay.io/podman/stable:v5.8.0

RUN dnf -y install podman-compose yq && dnf clean all

RUN git clone --depth 1 https://github.com/openwrt/asu

RUN mkdir -p /run/podman && chmod 777 /run/podman && chmod -R 777 /asu && \
  mkdir -p /tmp/images

USER podman

WORKDIR /asu

COPY ./images/* /tmp/images

COPY ./asu/entrypoint.sh /entrypoint.sh

EXPOSE 8000

VOLUME [ "/home/podman/.local/share/containers", "/asu/public" ]

ENTRYPOINT [ "/entrypoint.sh" ]
