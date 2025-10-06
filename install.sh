#!/bin/bash
# ==============================
# install.sh - dotfiles OpenSUSE
# ==============================

# -----------------------------
# Primeiro dotfiles ainda em construção, e tratando erros na execução!!
# -----------------------------

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
    vim unzip make \
    java-17-openjdk \
    python3 python3-pip \
    gcc gcc-c++ 

#php(LAMP)
sudo zypper install apache2 php8 apache2-mod_php8 mariadb mariadb-client mariadb-tools phpMyAdmin
sudo systemctl enable apache2
sudo systemctl start apache2
sudo systemctl enable mariadb
sudo systemctl start mariadb
sudo systemctl restart apache2

# Permissoes de acesso do apache
sudo usermod -aG wwwrun gabriel
sudo chown -R wwwrun:www /srv/www/htdocs
sudo chmod -R 777 /srv/www/htdocs/

# Caso não tenha permissao de acesso ao localhost:
#   sudo nano /etc/apache2/default-server.conf
# Verifique as linhas:
#   Options Indexes FollowSymLinks
#   AllowOverride All
#   Require all granted
#  sudo systemctl restart apache2

#PSQL
sudo zypper install postgresql -y 

# VSCode
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo zypper addrepo https://packages.microsoft.com/yumrepos/vscode vscode
sudo zypper install code

# Flatpak + Ulauncher 
sudo zypper install -y flatpak
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install -y flathub
sudo zypper install ulauncher

# -----------------------------
# 3. Criar diretórios de configuração
# -----------------------------
echo "Criando diretórios de configuração"
mkdir -p ~/.config/vscode
mkdir -p ~/.config/ulauncher

# -----------------------------
# 4. Copiar dotfiles
# -----------------------------
echo "Copiando arquivos"
cp .dotfiles/.bashrc ~/.bashrc
cp .dotfiles/.gitconfig ~/.gitconfig

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