#!/bin/bash

# Demander le nom et l'email de l'utilisateur pour la configuration de Git
read -p "Entrez votre nom pour Git: " name
read -p "Entrez votre adresse email pour Git: " email

# Mise à jour des paquets et installation des dépendances nécessaires
sudo apt update
sudo apt install curl software-properties-common wget gpg apt-transport-https ca-certificates lsb-release git -y

# Installation d'Apache2
sudo apt install apache2 -y
# Activer et démarrer le service Apache2
sudo systemctl enable apache2
sudo systemctl start apache2

# Configurer le nom et l'email pour Git
git config --global user.name "$name"
git config --global user.email "$email"

# Installation de PHP 8.3 et extensions
sudo apt install php8.3 php8.3-mysql php8.3-curl php8.3-mbstring php8.3-xml php8.3-intl -y
# Configuration d'Apache pour utiliser PHP
sudo a2enmod php8.3

# Installation des applications
# Google Chrome
wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | gpg --dearmor | sudo tee /usr/share/keyrings/google-archive-keyring.gpg >/dev/null
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/google-archive-keyring.gpg] http://dl.google.com/linux/chrome/deb/ stable main" | sudo tee /etc/apt/sources.list.d/google.list

# Microsoft Edge
wget -q -O - https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | sudo tee /usr/share/keyrings/microsoft-archive-keyring.gpg >/dev/null
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/microsoft-archive-keyring.gpg] https://packages.microsoft.com/repos/edge stable main" | sudo tee /etc/apt/sources.list.d/microsoft-edge-dev.list

# VS Code
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | sudo tee /usr/share/keyrings/vscode-archive-keyring.gpg >/dev/null
echo "deb [arch=amd64,arm64,armhf signed-by=/usr/share/keyrings/vscode-archive-keyring.gpg] https://packages.microsoft.com/repos/code stable main" | sudo tee /etc/apt/sources.list.d/vscode.list

# GitHub CLI
sudo mkdir -p -m 755 /etc/apt/keyrings
wget -qO- https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null
sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list

# Mettre à jour les paquets une fois tous les dépôts ajoutés
sudo apt update

# Installer les applications
sudo apt install google-chrome-stable microsoft-edge-stable code gh -y

# Installation de Composer
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php composer-setup.php
sudo mv composer.phar /usr/local/bin/composer
rm -f composer-setup.php

# Installation de Symfony CLI
echo 'deb [trusted=yes] https://repo.symfony.com/apt/ /' | sudo tee /etc/apt/sources.list.d/symfony-cli.list
sudo apt install symfony-cli -y

# Authentifier l'utilisateur sur GitHub
gh auth login

echo "Configuration de Git, GitHub CLI et autres outils terminée avec succès."

# Configuration de MariaDB
sudo mysql << EOF
create user 'admin'@'localhost' identified by 'Afpa1234';
grant all privileges on *.* to 'admin'@'localhost' with grant option;
flush privileges;
EOF
