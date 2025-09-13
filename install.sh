#!/bin/bash
# ==============================
# install.sh - dotfiles OpenSUSE
# ==============================

set -e # Para o script se der erro

# -----------------------------
# 1. Atualizar repositórios e pacotes
# -----------------------------
echo "Atualizando sistemas"
sudo zypper refresh && zypper update -y

# -----------------------------
# 2. Instalar programas essenciais
# -----------------------------
echo "Instalando programas"
sudo zypper install -y \
    vim neofetch unzip make \
    code \
    java-17-openjdk \
    python3 python3-pip \
    gcc g++ \
    ulauncher

# -----------------------------
# 3. Criar diretórios de configuração
# -----------------------------
echo "Criando diretórios de configuração"
mkdir -p $HOME/.config/neofetch
mkdir -p $HOME/.config/vscode
mkdir -p $HOME/.config/ulauncher

# -----------------------------
# 4. Copiar dotfiles
# -----------------------------
echo "Copiando arquivos"
cp .dotfiles/.bashrc $HOME/.bashrc
cp .dotfiles/.gitconfig $HOME/.gitconfig

cp .dotfiles/.config/neofetch/config.conf $HOME/.config/neofetch/config.conf

# VSCode
cp .dotfiles/.config/vscode/extensions.txt $HOME/.config/vscode/extensions.txt
cp .dotfiles/.config/vscode/settings.json $HOME/.config/vscode/settings.json
cp .dotfiles/.config/vscode/keybindings.json $HOME/.config/vscode/keybindings.json

# uLauncher
cp .dotfiles/.config/ulauncher/settings.json $HOME/.config/ulauncher/settings.json

# -----------------------------
# 5. Instalar extensões do VSCode
# -----------------------------
echo "Instalando extensões do VSCode..."
while read extension; do
    [[ "$extension" =~ ^#.*$ ]] && continue   # Ignora comentários
    [[ -z "$extension" ]] && continue         # Ignora linhas vazias
    code --install-extension "$extension"
done < $HOME/.config/vscode/extensions.txt

# -----------------------------
# 6. Tornar scripts executáveis
# -----------------------------
chmod +x $HOME/.config/ulauncher/ulauncher_start.sh 2>/dev/null || true

# -----------------------------
# 7. Finalização
# -----------------------------
echo "Instalação concluída!"
echo "Reinicie o terminal para aplicar as configurações .bashrc"
