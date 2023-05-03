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
    && echo -e '#!/bin/bash\nkubectl exec -it $(kubectl get po -l run=$1 -o name) -- $2' > /usr/bin/kexec \
    && chmod +x /usr/bin/kexec

USER kubettyd
WORKDIR /home/kubettyd

EXPOSE 7681

ENTRYPOINT [ "/usr/bin/tini", "--" ]
CMD [ "ttyd", "bash" ]