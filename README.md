# DocuBus

Les documents du Bus 31/32, à Marseille : documents vierges rangés par catégories, et attestation de délivrance exceptionnelle de TSO envoyée au CSAPA de suivi.

**Lien de l'appli : https://bus3132.github.io/docubus/**
**Accès admin (sur ordinateur) : https://bus3132.github.io/docubus/admin.html**

![DocuBus](img/logo.svg)

## Pour l'équipe (téléphone)

### Onglet Documents
Les documents vierges, rangés par catégories : Informations, Orientations, Dossier Inclusion, Délivrance exceptionnelle, Classeur bus. On peut chercher un document, l'ouvrir (pour l'imprimer) ou le partager.

### Onglet Délivrance
1. Choisir le **CSAPA de suivi** dans la liste, ou « Autre » pour taper une adresse.
2. Pour chaque patient : civilité, **initiales**, date de naissance, n° de dossier (facultatif), traitement (méthadone ou buprénorphine), forme (facultatif), et chaque date avec sa dose.
3. **Préparer l'envoi** : un PDF est créé par patient.
4. **Partager** : les adresses du CSAPA sont copiées en même temps. Choisir Outlook, puis dans « À » : appui long → Coller.
5. **Mail envoyé : effacer le formulaire.**

Rien n'est enregistré sur le téléphone. Fermer la page efface aussi tout.

### Installer l'appli
Bouton **Installer** en haut de l'appli, ou lien en bas de page (Safari sur iPhone, Chrome sur Android).

## Pour les admins (ordinateur)

Lien **Accès admin** en bas de l'appli, puis le code admin.

- **Documents** : glisser-déposer de nouveaux fichiers, nouvelle version, renommer, déplacer, supprimer ; créer, renommer, ordonner les catégories.
- **Listes de diffusion** : les CSAPA et leurs adresses. Textes imprimés sur les attestations (signataire, en-tête, pied de page).
- **Sécurité** : changer le code (à chaque départ d'un admin), remplacer la clé GitHub.

Les changements apparaissent dans l'appli en 1 à 2 minutes.

### Première configuration, code oublié, clé expirée
Réservé au titulaire du compte GitHub de l'association. Sur la page admin : **Nouvelle configuration**, puis suivre les étapes affichées (créer une clé GitHub limitée au dépôt `docubus`, permission *Contents : Read and write*, puis choisir le code).

## Sécurité
Voir [SECURITE.md](SECURITE.md).

## Fichiers

- `index.html` : l'appli de l'équipe
- `admin.html` : la page admin
- `config/documents.json` : catégories et liste des documents (modifié par la page admin)
- `config/listes.json` : listes de diffusion (modifié par la page admin)
- `config/structure.json` : textes imprimés sur les attestations
- `config/cle.json` : clé GitHub **chiffrée** par le code admin (créé à la première configuration)
- `documents/` : les fichiers des documents vierges
- `css/`, `fonts/`, `img/`, `lib/` : styles, polices (SIL OFL), logos, jsPDF (licence MIT)
- `manifest.webmanifest`, `sw.js` : installation sur l'écran d'accueil et fonctionnement hors connexion
