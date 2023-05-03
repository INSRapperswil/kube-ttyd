FROM ubuntu:23.04

RUN useradd --create-home --shell /bin/bash kubettyd
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
      ca-certificates \
      curl \
      tini \
      ttyd \
    && rm -rf /var/lib/apt/lists/*

RUN curl -LO https://dl.k8s.io/release/v1.27.0/bin/linux/amd64/kubectl && install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

USER kubettyd
WORKDIR /home/kubettyd

RUN echo "kexec() { kubectl exec -it \$(kubectl get po -l run=\$1 -o name) -- \$2 ; }" >> $HOME/.bashrc

EXPOSE 7681

ENTRYPOINT [ "/usr/bin/tini", "--" ]
CMD [ "ttyd", "bash" ]