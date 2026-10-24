# DocuBus : sécurité et limites

Note destinée à la direction et au DPO du Bus 31/32.

## Ce que fait l'appli, en une phrase

Réservée à l'équipe, elle donne accès aux documents vierges de l'association. Elle fabrique aussi une attestation PDF **dans le téléphone**, puis la passe à **Outlook**, qui l'envoie. L'appli elle-même n'envoie aucune donnée patient à personne.

## Où sont les choses

| Quoi | Où | Qui y a accès |
|---|---|---|
| Code de l'appli (la « coquille ») | GitHub, public | Tout le monde : il ne contient aucune donnée |
| Documents vierges, liste des CSAPA, textes des attestations | Base Supabase de l'annuaire (Europe) | Membres de l'annuaire connectés. Seuls les administrateurs peuvent les modifier |
| Données patient (initiales, naissance, doses) | Mémoire du téléphone, le temps de la saisie | L'agent qui saisit. Rien n'est enregistré |
| Attestation envoyée | Outlook (boîtes d'envoi et de réception) | Expéditeur et CSAPA destinataire |

## Les protections en place

**Accès nominatif.** Chaque agent se connecte avec son adresse e-mail, par un lien ou un code reçu par mail. Ce sont les mêmes comptes que l'annuaire Annubus. Un départ se traite en retirant l'adresse dans Annubus.

**Contrôle fait par la base, pas par l'appli.** Les règles d'accès sont dans la base elle-même. Même quelqu'un qui modifierait le code de l'appli ne pourrait :
- ni lire les documents sans être membre ;
- ni les modifier sans être administrateur.

Ces règles ont été testées.

**Traçabilité.** Chaque modification d'un document, d'un destinataire ou d'un texte enregistre sa date et l'adresse de son auteur. C'est la base qui les remplit, ils ne peuvent pas être falsifiés.

**Documents privés.** Les fichiers sont dans un espace de stockage privé. Les liens d'ouverture sont temporaires (1 heure) et propres à la personne connectée.

**Rien n'est enregistré pour les patients.** Le formulaire vit uniquement dans la mémoire de la page : pas de sauvegarde, pas d'historique, pas de saisie semi-automatique, et aucun envoi à la base. Il est vidé après l'envoi ou à la fermeture de la page.

**Le PDF est fabriqué sur place.** Aucun service extérieur n'est appelé et aucune statistique de visite n'est collectée.

**Données réduites au minimum.** Initiales, date de naissance, n° de dossier facultatif, traitement, dates et doses. Pas de nom. Rien dans l'objet, le corps du mail ou le nom des fichiers.

## Les limites et risques résiduels

**1. Le mail lui-même (risque principal).** Outlook n'est pas une messagerie sécurisée de santé (MSSanté). Le mail et le PDF restent en clair dans les boîtes d'envoi et de réception. L'appli ne peut pas corriger cela. Pistes :
- activer le chiffrement Microsoft 365, si la licence le permet ;
- passer à terme sur MSSanté ;
- demander une adresse professionnelle au Dr Lutaud, plutôt que son adresse Gmail actuelle.

**2. Erreur de destinataire.** La liste préétablie réduit le risque. Le nom du CSAPA est rappelé avant l'envoi.

**3. Le téléphone.** Un téléphone connecté donne accès aux documents vierges, et le mail envoyé reste dans Outlook. Il faut des téléphones professionnels verrouillés par un code.

**4. Le PDF peut être imité.** Le code de l'appli est public. Le tampon de l'association, stocké dans la base et réservé aux membres, empêche une personne extérieure de produire facilement une attestation complète. Mais chaque CSAPA reçoit ce tampon dans les PDF et pourrait le recopier. Ce risque est faible et existait déjà avec le formulaire papier faxé. La garantie d'authenticité est **l'adresse Outlook de l'expéditeur**. Les CSAPA ne doivent pas se fier à un PDF apporté par un patient ou reçu d'une autre adresse ; en cas de doute, ils appellent le 04 86 11 09 14.

**5. Les comptes administrateurs et le compte Supabase.** Un administrateur de l'annuaire peut tout modifier dans DocuBus. Il faut :
- peu d'administrateurs ;
- des administrateurs retirés à leur départ ;
- un compte Supabase au nom de l'association, avec double authentification.

**6. La base gratuite.** Elle se met en pause après 7 jours sans activité. La tâche quotidienne d'Annubus l'en empêche ; si elle échoue, GitHub prévient par mail.

**7. Hébergeurs.** GitHub (Microsoft, États-Unis) héberge le code. Supabase (région Europe) héberge les documents vierges et les adresses des CSAPA. Aucun des deux n'héberge de données patient.

## À faire valider

- Inscription du traitement au **registre RGPD**, et information des patients.
- Avis du **DPO** sur l'envoi par Outlook et sur l'adresse Gmail.
- Disponibilité du chiffrement Microsoft 365.
- Liste des administrateurs, et personnes qui détiennent les comptes GitHub et Supabase de l'association.
