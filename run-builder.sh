#!/bin/bash

# Script para executar o container de build com acesso ao socket do Podman

set -e

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}🚀 Configurando container de build para nanoEmacs${NC}"

# Verificar se o socket do Podman existe
PODMAN_SOCKET="/run/user/$(id -u)/podman/podman.sock"
if [[ ! -S "$PODMAN_SOCKET" ]]; then
    echo -e "${YELLOW}⚠️  Socket do Podman não encontrado. Iniciando serviço...${NC}"
    systemctl --user start podman.socket
    sleep 2
fi

# Verificar novamente
if [[ ! -S "$PODMAN_SOCKET" ]]; then
    echo -e "${RED}❌ Erro: Socket do Podman não está disponível em $PODMAN_SOCKET${NC}"
    echo -e "${YELLOW}💡 Tente executar: systemctl --user start podman.socket${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Socket do Podman encontrado: $PODMAN_SOCKET${NC}"

# Construir a imagem do builder se não existir
if ! podman image exists kubler-builder:latest; then
    echo -e "${YELLOW}🔨 Construindo imagem do builder...${NC}"
    podman build -t kubler-builder:latest -f Dockerfile.builder .
fi

echo -e "${GREEN}🏃 Executando container de build...${NC}"

# Executar o container com acesso ao socket do Podman
podman run -it --rm \
    --name kubler-build-env \
    --security-opt label=disable \
    --security-opt seccomp=unconfined \
    --device /dev/fuse \
    --cap-add SYS_ADMIN \
    --cap-add MKNOD \
    -v "$PODMAN_SOCKET:/run/podman/podman.sock:Z" \
    -v "$(pwd):/workspace:Z" \
    -e CONTAINER_HOST="unix:///run/podman/podman.sock" \
    kubler-builder:latest

echo -e "${GREEN}✅ Container finalizado${NC}"