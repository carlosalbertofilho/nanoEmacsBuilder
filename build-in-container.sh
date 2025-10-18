#!/bin/bash

# Script para executar dentro do container de build

set -e

echo "🚀 Iniciando build do nanoEmacs com Kubler..."

# Verificar se estamos no diretório correto
if [[ ! -f "kubler.conf" ]]; then
    echo "❌ Erro: arquivo kubler.conf não encontrado"
    echo "💡 Execute este script do diretório /home/builder/nanoEmacsBuilder/emacs"
    exit 1
fi

# Usar a configuração específica para container se disponível
if [[ -f "kubler.container.conf" ]]; then
    echo "📋 Usando configuração específica para container"
    cp kubler.container.conf kubler.conf
fi

# Verificar se o Kubler está disponível
if ! command -v kubler >/dev/null 2>&1; then
    echo "❌ Erro: kubler não encontrado no PATH"
    echo "💡 PATH atual: $PATH"
    exit 1
fi

echo "✅ Kubler encontrado: $(which kubler)"

# Verificar se o Podman está funcionando
if ! podman version >/dev/null 2>&1; then
    echo "❌ Erro: Podman não está funcionando"
    echo "💡 Verifique se o socket está montado corretamente"
    exit 1
fi

echo "✅ Podman funcionando: $(podman version --format '{{.Client.Version}}')"

# Atualizar informações do Kubler
echo "🔄 Atualizando informações do Kubler..."
kubler update

# Executar o build
echo "🏗️  Iniciando build do emacs/nanoemacs..."
kubler build emacs/nanoemacs --skip-gpg-check -v

echo "✅ Build concluído com sucesso!"
echo "🎉 Imagem emacs/nanoemacs está pronta para uso!"