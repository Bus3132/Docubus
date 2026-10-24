# DocuBus (accès réservé à l'équipe)

Les documents du Bus 31/32, à Marseille : documents vierges rangés par catégories, et attestation de délivrance exceptionnelle de TSO envoyée au CSAPA de suivi.

**Adresse : https://bus3132.github.io/Docubus/**

![Docubus](img/logo-docubus.png)

**Aucun document ni aucune adresse n'est stocké dans ce dépôt public.** Tout est dans la base Supabase de l'annuaire Annubus, et seuls les membres de l'annuaire y ont accès. Aucune donnée patient n'est stockée nulle part.

## Pour l'équipe

**Connexion** : la même que pour Annubus. On tape son adresse e-mail, on reçoit un lien ou un code à 6 chiffres, et on reste connecté sur le téléphone.

**Onglet Documents** : les documents vierges, rangés par catégories. On peut chercher un document, l'ouvrir (pour l'imprimer) ou le partager.

**Onglet Délivrance** :
1. Choisir le CSAPA de suivi, ou « Autre ».
2. Pour chaque patient, remplir les initiales, la date de naissance, le traitement, les dates et les doses.
3. **Préparer l'envoi** crée un PDF par patient.
4. **Partager** copie aussi les adresses. Dans Outlook, appui long dans « À », puis Coller.
5. **Mail envoyé : effacer le formulaire.**

Rien n'est enregistré, ni sur le téléphone ni dans la base.

## Pour les administrateurs

Les administrateurs de l'annuaire voient un onglet **Admin** :
- **Documents** : ajouter, déposer une nouvelle version, renommer, déplacer ou supprimer un document ; gérer les catégories.
- **Destinataires** : les CSAPA et leurs adresses.
- **Textes des attestations** : signataire, en-tête et pied de page.

Qui peut se connecter, et qui est administrateur : cela se gère dans **Annubus**, bouton « Accès ».

## Mise en place (une seule fois, dans Supabase)

1. *SQL Editor* > *New query* : coller `supabase-docubus.sql`, puis *Run*.
   Ce script crée les tables `docubus_*` et l'espace de stockage privé `docubus`, avec les règles d'accès. Il réutilise la table `membres` d'Annubus.
2. *Authentication* > *URL Configuration* > *Redirect URLs* : ajouter `https://bus3132.github.io/Docubus/`. Ne pas toucher au *Site URL* d'Annubus.
3. GitHub, dépôt `Docubus` > *Settings* > *Pages* : *Deploy from a branch*, branche `main`, dossier `/ (root)`.

La mise en veille de la base gratuite est déjà évitée par la tâche quotidienne d'Annubus, puisque c'est la même base.

## Fichiers

- `index.html` : l'appli (connexion, documents, délivrance, admin)
- `config.js` : adresse de la base et clé publique (les mêmes que pour Annubus)
- `supabase-docubus.sql` : tables, stockage et règles d'accès à installer dans Supabase
- `SECURITE.md` : note sécurité pour la direction et le DPO
- `css/`, `fonts/`, `img/`, `lib/` (jsPDF, MIT), `vendor/` (supabase-js 2.45.4, MIT)
- `manifest.webmanifest`, `sw.js` : installation sur l'écran d'accueil
