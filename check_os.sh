#!/bin/bash

# Vérifier que lsb_release est installé
if ! command -v lsb_release >/dev/null 2>&1; then
  echo "Le paquet lsb-release n'est pas installé. Installation..."
  sudo apt-get update && sudo apt-get install -y lsb-release
fi

# Récupération du nom de la distribution (Ubuntu, Debian, Fedora, etc.)
DISTRO=$(lsb_release -is)

# Récupération de la version (20.04, 10, etc.)
VERSION=$(lsb_release -rs)

echo "Distribution : $DISTRO"
echo "Version      : $VERSION"

case "$DISTRO" in
  Ubuntu)
    echo "-> Exécution du script pour Ubuntu"
# Demander le nom et l'email de l'utilisateur pour la configuration de Git
read -p "Entrez votre nom pour Git: " name
read -p "Entrez votre adresse email pour Git: " email

# Mise à jour des paquets et installation des dépendances nécessaires
sudo apt update && sudo apt upgrade -y
sudo apt install curl software-properties-common wget gpg apt-transport-https ca-certificates lsb-release git -y

# Installation d'Apache2
sudo apt install apache2 -y
sudo systemctl enable apache2
sudo systemctl start apache2

# Installation de PHP 8.3 et des extensions nécessaires
sudo apt install php8.3 php8.3-mysql php8.3-curl php8.3-mbstring php8.3-xml php8.3-intl php8.3-gd php8.3-zip -y
sudo a2enmod php8.3
sudo systemctl restart apache2

# Configuration du git global
git config --global user.name "$name"
git config --global user.email "$email"

# Installation de MariaDB
sudo apt install software-properties-common -y
sudo apt-key adv --fetch-keys 'https://mariadb.org/mariadb_release_signing_key.asc'
sudo add-apt-repository 'deb [arch=amd64] http://mariadb.mirror.liquidtelecom.com/repo/10.5/ubuntu $(lsb_release -cs) main'
sudo apt update
sudo apt install mariadb-server -y
sudo mysql_secure_installation

# Configuration initiale de MariaDB
sudo mysql <<EOF
CREATE USER 'admin'@'localhost' IDENTIFIED BY 'Afpa1234';
GRANT ALL PRIVILEGES ON *.* TO 'admin'@'localhost' WITH GRANT OPTION;
FLUSH PRIVILEGES;
EOF

# Ajout des dépôts pour les applications et mise à jour des paquets

#wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | sudo tee /usr/share/keyrings/microsoft-edge-keyring.gpg >/dev/null
#echo "deb [arch=amd64 signed-by=/usr/share/keyrings/microsoft-edge-keyring.gpg] https://packages.microsoft.com/repos/edge stable main" | sudo tee /etc/apt/sources.list.d/microsoft-#edge-dev.list

#wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | sudo tee /usr/share/keyrings/vscode-keyring.gpg >/dev/null
#echo "deb [arch=amd64,arm64,armhf signed-by=/usr/share/keyrings/vscode-keyring.gpg] https://packages.microsoft.com/repos/code stable main" | sudo tee /etc/apt/sources.list.d/#vscode.list

#wget -qO- https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo tee /etc/apt/keyrings/githubcli-keyring.gpg >/dev/null
#echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/#github-cli.list

sudo apt update
#sudo apt install microsoft-edge-stable code -y

(type -p wget >/dev/null || (sudo apt update && sudo apt-get install wget -y)) \
&& sudo mkdir -p -m 755 /etc/apt/keyrings \
&& wget -qO- https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null \
&& sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
&& echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
&& sudo apt update \
&& sudo apt install gh -y

# Installation de Composer et Symfony CLI
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php composer-setup.php
sudo mv composer.phar /usr/local/bin/composer
rm composer-setup.php

echo 'deb [trusted=yes] https://repo.symfony.com/apt/ /' | sudo tee /etc/apt/sources.list.d/symfony-cli.list
sudo apt update
sudo apt install symfony-cli -y

# Authentification GitHub CLI
#gh auth login

echo "Configuration terminée avec succès."
    ;;
  Debian)
    echo "-> Exécution du script pour Debian"
    # ...
    ;;
  Linuxmint)
    echo "-> Exécution du script pour Linux Mint"
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


# Installation MariaDB
sudo apt install mariadb-server -y


# Configuration de MariaDB
sudo mysql << EOF
create user 'admin'@'localhost' identified by 'Afpa1234';
grant all privileges on *.* to 'admin'@'localhost' with grant option;
flush privileges;
EOF


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
curl -1sLf 'https://dl.cloudsmith.io/public/symfony/stable/setup.deb.sh' | sudo -E bash
sudo apt install symfony-cli -y


# Ajouter la clé GPG et le dépôt de GitHub CLI
sudo mkdir -p -m 755 /etc/apt/keyrings
wget -qO- https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null
sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null


# Mettre à jour les paquets et installer Dbeaver
sudo apt update

sudo  wget -O /usr/share/keyrings/dbeaver.gpg.key https://dbeaver.io/debs/dbeaver.gpg.key
echo "deb [signed-by=/usr/share/keyrings/dbeaver.gpg.key] https://dbeaver.io/debs/dbeaver-ce /" | sudo tee /etc/apt/sources.list.d/dbeaver.list
sudo apt-get update && sudo apt-get install dbeaver-ce -y


    ;;
  *)
    echo "Distribution non reconnue ou non supportée : $DISTRO"
    ;;
esac


# Codes couleurs pour la lisibilité (vert, rouge, reset)
COLOR_GREEN="\033[32m"
COLOR_RED="\033[31m"
COLOR_RESET="\033[0m"


# Liste des commandes à tester
COMMANDS=(
	"curl"
	"wget"
	"gpg"
 	"git"
 	"php"
 	"mysql"
 	"code"
 	"composer"
 	"symfony"
 	"dbeaver-ce"
)


for cmd in "${COMMANDS[@]}"; do
  if command -v "$cmd" >/dev/null 2>&1; then
    echo -e "***** $cmd -> ${COLOR_GREEN}TRUE${COLOR_RESET} *****"
  else
    echo -e "***** $cmd -> ${COLOR_RED}FALSE${COLOR_RESET} *****"
  fi
done
    
