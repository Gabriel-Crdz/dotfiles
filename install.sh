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
    java-17-openjdk \
    python3 python3-pip \
    gcc gcc-g++ 

#php(LAMP)
sudo zypper install apache2 php8.2 apache2-mod_php8 php8.2-mysql -y
sudo systemctl enable apache2
sudo systemctl start apache2
sudo chown -R $USER:$USER /srv/www/htdocs

# VSCode
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo zypper addrepo https://packages.microsoft.com/yumrepos/vscode vscode
sudo zypper refresh
sudo zypper install code

# Flatpak + Ulauncher 
sudo zypper install -y flatpak
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install -y flathub

# -----------------------------
# 3. Criar diretórios de configuração
# -----------------------------
echo "Criando diretórios de configuração"
mkdir -p ~/.config/neofetch
mkdir -p ~/.config/vscode
mkdir -p ~/.config/ulauncher

# -----------------------------
# 4. Copiar dotfiles
# -----------------------------
echo "Copiando arquivos"
cp .dotfiles/.bashrc ~/.bashrc
cp .dotfiles/.gitconfig ~/.gitconfig

cp .dotfiles/.config/neofetch/config.conf ~/.config/neofetch/config.conf

# VSCode
cp .dotfiles/.config/vscode/extensions.txt ~/.config/vscode/extensions.txt
cp .dotfiles/.config/vscode/settings.json ~/.config/vscode/settings.json
cp .dotfiles/.config/vscode/keybindings.json ~/.config/vscode/keybindings.json

# uLauncher
cp .dotfiles/.config/ulauncher/settings.json ~/.config/ulauncher/settings.json
cp -r ~/dotfiles/.config/ulauncher/themes/viridian ~/.config/ulauncher/user-themes/

# -----------------------------
# 5. Instalar extensões do VSCode
# -----------------------------
echo "Instalando extensões do VSCode..."
while read extension; do
    [[ "$extension" =~ ^#.*$ ]] && continue   # Ignora comentários
    [[ -z "$extension" ]] && continue         # Ignora linhas vazias
    code --install-extension "$extension"
done < ~/.config/vscode/extensions.txt

# -----------------------------
# 6. Tornar scripts executáveis
# -----------------------------
cat > ~/.config/autostart/ulauncher.desktop <<EOL
[Desktop Entry]
Type=Application
Name=Ulauncher
Comment=Start Ulauncher at login
Exec=flatpak run com.github.Ulauncher
Terminal=false
X-GNOME-Autostart-enabled=true
EOL

chmod +x ~/.config/ulauncher/ulauncher_start.sh 2>/dev/null || true

# -----------------------------
# 7. Finalização
# -----------------------------
echo "Instalação concluída!"
echo "Reinicie o terminal para aplicar as configurações .bashrc"
