#!/bin/bash

# Demander le nom et l'email de l'utilisateur pour la configuration de Git
read -p "Entrez votre nom pour Git: " name
read -p "Entrez votre adresse email pour Git: " email

# Mise à jour des paquets et installation des dépendances nécessaires
sudo apt update
sudo apt upgrade -y
sudo apt install curl software-properties-common wget gpg apt-transport-https ca-certificates lsb-release git -y

# Configurer le nom et l'email pour Git
git config --global user.name "$name"
git config --global user.email "$email"

# Installation de PHP 8 et extensions
sudo apt install php php-mysql php-curl php-mbstring php-xml php-intl php-dev -y

# Installation de Google Chrome
#wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | gpg --dearmor | sudo tee /usr/share/keyrings/google-archive-keyring.gpg >/dev/null
#echo "deb [arch=amd64 signed-by=/usr/share/keyrings/google-archive-keyring.gpg] http://dl.google.com/linux/chrome/deb/ stable main" | sudo tee /etc/apt/sources.list.d/google.list
#sudo apt update
#sudo apt install google-chrome-stable -y

# Installation de VS Code
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | sudo tee /usr/share/keyrings/vscode-archive-keyring.gpg >/dev/null
echo "deb [arch=amd64,arm64,armhf signed-by=/usr/share/keyrings/vscode-archive-keyring.gpg] https://packages.microsoft.com/repos/code stable main" | sudo tee /etc/apt/sources.list.d/vscode.list
sudo apt update
sudo apt install code -y

# Installation de Composer
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php composer-setup.php
sudo mv composer.phar /usr/local/bin/composer
rm -f composer-setup.php

# Installation de Symfony CLI
echo 'deb [trusted=yes] https://repo.symfony.com/apt/ /' | sudo tee /etc/apt/sources.list.d/symfony-cli.list

# Ajouter la clé GPG et le dépôt de GitHub CLI
sudo mkdir -p -m 755 /etc/apt/keyrings
wget -qO- https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null
sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null

# Mettre à jour les paquets et installer GitHub CLI
sudo apt update
#sudo apt install gh -y

# Authentifier l'utilisateur sur GitHub
#gh auth login

echo "Configuration de Git, GitHub CLI et autres outils terminée avec succès."

# Installation MariaDB
sudo apt install mariadb-server

# Configuration de MariaDB
sudo mysql << EOF
create user 'admin'@'localhost' identified by 'Afpa1234';
grant all privileges on *.* to 'admin'@'localhost' with grant option;
flush privileges;
EOF

sudo  wget -O /usr/share/keyrings/dbeaver.gpg.key https://dbeaver.io/debs/dbeaver.gpg.key
echo "deb [signed-by=/usr/share/keyrings/dbeaver.gpg.key] https://dbeaver.io/debs/dbeaver-ce /" | sudo tee /etc/apt/sources.list.d/dbeaver.list
sudo apt-get update && sudo apt-get install dbeaver-ce
