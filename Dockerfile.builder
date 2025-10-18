FROM fedora:latest

# Instalar dependências necessárias
RUN dnf update -y && \
    dnf install -y \
    git \
    bash \
    curl \
    wget \
    jq \
    podman \
    buildah \
    skopeo \
    fuse-overlayfs \
    slirp4netns \
    && dnf clean all

# Configurar usuário para evitar problemas de permissão
RUN useradd -m -s /bin/bash builder && \
    echo "builder ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Configurar podman para funcionar sem root
RUN mkdir -p /home/builder/.config/containers && \
    echo 'unqualified-search-registries = ["docker.io"]' > /home/builder/.config/containers/registries.conf

USER builder
WORKDIR /home/builder

# Clonar repositórios
RUN git clone https://github.com/carlosalbertofilho/nanoEmacsBuilder.git && \
    git clone https://github.com/edannenberg/kubler.git

# Configurar PATH para o kubler
ENV PATH="/home/builder/kubler/bin:$PATH"

# Definir diretório de trabalho
WORKDIR /home/builder/nanoEmacsBuilder

CMD ["/bin/bash"]