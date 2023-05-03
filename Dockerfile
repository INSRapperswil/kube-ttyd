FROM ubuntu:23.04

RUN useradd --create-home --shell /bin/bash kubettyd
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
      ca-certificates \
      curl \
      tini \
      ttyd \
    && rm -rf /var/lib/apt/lists/*

RUN curl -LO https://dl.k8s.io/release/v1.27.0/bin/linux/amd64/kubectl \
    && install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl \
    && curl -LO https://github.com/kubevirt/kubevirt/releases/download/v0.59.0/virtctl-v0.59.0-linux-amd64 \
    && mv virtctl-v0.59.0-linux-amd64 /usr/local/bin/virtctl \
    && chmod +x /usr/local/bin/virtctl

ADD konnect /usr/local/bin/konnect
RUN chmod +x /usr/local/bin/konnect

USER kubettyd
WORKDIR /home/kubettyd

EXPOSE 7681

ENTRYPOINT [ "/usr/bin/tini", "--" ]
CMD [ "ttyd", "bash" ]