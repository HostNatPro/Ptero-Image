# Pterodactyl Custom Images (Dynamic Matrix)

Ce dépôt contient des images Docker custom pour Pterodactyl (compatibles AMD64 & ARM64), gérées de manière entièrement modulaire.
Elles sont optimisées pour être **prêtes à l'emploi** et évitent l'exécution de scripts d'installation lourds à chaque démarrage ou installation de serveur.

## 🚀 Fonctionnement Modulaire (Pas de hardcode dans le workflow)

Le workflow GitHub Actions détecte dynamiquement les images à construire. Chaque dossier sous `images/` contenant un fichier `manifest.json` sera détecté et compilé selon les versions spécifiées.

## 📦 Structure du Projet

```text
├── .github/
│   ├── scripts/
│   │   └── generate-matrix.sh  # Générateur dynamique de matrice pour GitHub Actions
│   └── workflows/
│       └── build.yml           # CI/CD dynamique qui lit les dossiers et manifests
└── images/
    ├── node/
    │   ├── manifest.json       # Configuration (versions, plateformes, tag latest)
    │   ├── Dockerfile          # Dockerfile générique utilisant ARG VERSION
    │   └── entrypoint.sh       # Script de démarrage Pterodactyl
    └── bun/
        ├── manifest.json
        ├── Dockerfile
        └── entrypoint.sh
```

## ➕ Comment ajouter une nouvelle image (ex: Python, PHP, etc.) ?

1. Créez un nouveau dossier sous `images/` (ex: `images/python`).
2. Créez un fichier `manifest.json` à l'intérieur :
   ```json
   {
     "versions": ["3.10", "3.11", "3.12"],
     "platforms": ["linux/amd64", "linux/arm64"],
     "latest_version": "3.12"
   }
   ```
3. Créez votre `Dockerfile` en utilisant `ARG VERSION` pour la version de l'image de base :
   ```dockerfile
   ARG VERSION=3.12
   FROM --platform=$TARGETPLATFORM python:${VERSION}-slim
   # Vos installations d'outils...
   ```
4. Ajoutez votre script `entrypoint.sh`.
5. Poussez sur la branche `main` ! GitHub Actions s'occupe de tout compiler et publier sur GHCR.

## ⚙️ Intégration dans Pterodactyl

Dans le panel Pterodactyl, modifiez le champ **Docker Images** de votre Egg pour pointer vers votre registre de paquets :
- **Node 22** (LTS/latest) : `ghcr.io/votre-username-github/ptero-image/node:22` ou `ghcr.io/votre-username-github/ptero-image/node:latest`
- **Bun** : `ghcr.io/votre-username-github/ptero-image/bun:latest`
- **Node 20** : `ghcr.io/votre-username-github/ptero-image/node:20`
