Voici une **documentation complète pour LMDE 6 Faye**, incluant :

* l’installation de Docker,
* l’installation de Docker Compose (via plugin),
* l’installation facultative de **Portainer**, avec explication de son intérêt.

---

# 🐳 Installation complète de Docker + Docker Compose + Portainer sur LMDE 6

## 🔹 1. **Préparation : suppression d’anciens paquets**

```bash
sudo apt remove docker docker-engine docker.io containerd runc
```

---

## 🔹 2. **Installation des dépendances**

```bash
sudo apt update
sudo apt install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
```

---

## 🔹 3. **Ajout de la clé GPG officielle de Docker**

```bash
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | \
  sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
```

---

## 🔹 4. **Ajout du dépôt Docker pour Debian 12**

```bash
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```

---

## 🔹 5. **Installation de Docker CE, CLI et Compose**

```bash
sudo apt update
sudo apt install -y \
  docker-ce \
  docker-ce-cli \
  containerd.io \
  docker-buildx-plugin \
  docker-compose-plugin
```

### ➕ Vérification :

```bash
docker --version
docker compose version
```

---

## 🔹 6. **Tester Docker**

```bash
sudo docker run hello-world
```

---

## 🔹 7. **(Optionnel) Utiliser Docker sans sudo**

```bash
sudo usermod -aG docker $USER
```

➡️ **Déconnecte-toi / reconnecte-toi** ensuite pour que cela prenne effet.

---

## 🧭 8. **(Optionnel) Installation de Portainer**

### 🔸 Qu’est-ce que Portainer ?

**Portainer** est une interface web pour gérer Docker visuellement :

* voir les containers en cours,
* démarrer/arrêter/supprimer un container,
* lancer des stacks avec docker-compose,
* créer des volumes,
* accéder aux logs, etc.

Il est **très utile pédagogiquement** pour suivre et gérer les containers sans ligne de commande.

### 🔸 Installation de Portainer :

```bash
docker volume create portainer_data

docker run -d -p 9000:9000 -p 9443:9443 \
  --name portainer \
  --restart=always \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v portainer_data:/data \
  portainer/portainer-ce:latest
```

### ➕ Accès :

Ouvre ton navigateur à l'adresse :
**[http://localhost:9000](http://localhost:9000)**

➡️ Crée ton utilisateur admin.
➡️ Connecte-toi à l’environnement local (Docker socket).

---

## ✅ Résumé final

| Composant          | Statut                  | Commande de base         |
| ------------------ | ----------------------- | ------------------------ |
| Docker Engine      | ✅ installé              | `docker run hello-world` |
| Docker Compose     | ✅ via plugin            | `docker compose up -d`   |
| Portainer (web UI) | ✅ optionnel, très utile | `http://localhost:9000`  |


