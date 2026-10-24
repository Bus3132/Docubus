# DocuBus : sécurité et limites

Note destinée à la direction et au DPO du Bus 31/32.

## Ce que fait l'appli, en une phrase

Elle fabrique une attestation PDF **dans le téléphone**, puis la passe à **Outlook**, qui l'envoie. L'appli elle-même n'envoie rien à personne.

## Les protections en place

**Pas de serveur, pas de base de données.** L'appli est une simple page web hébergée sur GitHub Pages. Il n'existe aucun endroit où les données des patients pourraient être stockées ou piratées en masse.

**Rien n'est enregistré sur le téléphone.** Le formulaire vit uniquement dans la mémoire de la page : pas de sauvegarde, pas d'historique, pas de saisie semi-automatique. Il est vidé après l'envoi, ou dès qu'on ferme la page.

**Le PDF est fabriqué sur place.** La bibliothèque qui crée le PDF est copiée dans l'appli : aucun service extérieur n'est appelé, aucune statistique de visite n'est collectée.

**Données réduites au minimum.** Initiales, date de naissance, n° de dossier facultatif, traitement, dates et doses. Pas de nom. Le corps du mail, l'objet et le nom des fichiers ne contiennent aucune donnée patient : tout est dans la pièce jointe.

**Partage direct vers Outlook.** Sur téléphone, le PDF est transmis par le bouton Partager, sans passer par le dossier Téléchargements.

**Accès admin protégé.** Les modifications (documents, listes de diffusion) passent par une clé GitHub :
- limitée au seul dépôt DocuBus ;
- stockée chiffrée (AES-256, clé dérivée du code admin avec 600 000 itérations de PBKDF2) ;
- jamais visible en clair.

Chaque modification est historisée par GitHub et peut être annulée.

## Les limites et risques résiduels

**1. Le mail lui-même (risque principal).** Outlook n'est pas une messagerie sécurisée de santé (MSSanté). Le mail et sa pièce jointe sont conservés en clair dans la boîte d'envoi du Bus et dans celle du destinataire. L'appli ne peut pas corriger cela. Pistes :
- activer le chiffrement des mails de Microsoft 365, si la licence le permet ;
- passer à terme sur MSSanté ;
- demander une adresse professionnelle au Dr Lutaud, plutôt que son adresse Gmail actuelle (messagerie grand public, non hébergée comme une donnée de santé).

**2. Erreur de destinataire.** La liste préétablie réduit ce risque, mais une mauvaise sélection ou une adresse libre mal tapée reste possible. Le nom du CSAPA est rappelé avant l'envoi.

**3. Le téléphone.** Après envoi, le mail reste dans les « Éléments envoyés » d'Outlook. Il faut donc :
- des téléphones professionnels, verrouillés par un code ;
- des comptes Outlook personnels à chaque agent ou bien gérés.

Sur ordinateur, le partage direct n'existe pas : les PDF passent par Téléchargements et doivent être supprimés après l'envoi. L'appli le rappelle.

**4. Le site est public.** Toute personne ayant l'adresse voit les documents vierges et les adresses professionnelles des CSAPA. Aucune donnée patient n'y figure. N'y mettre aucun document interne confidentiel.

**5. Un code admin partagé.** Les 1 ou 2 admins utilisent le même code. Conséquences :
- on ne sait pas lequel a fait une modification ;
- un ancien admin connaît le code tant qu'il n'est pas changé : il faut le **changer à chaque départ**, en 30 secondes dans l'onglet Sécurité ;
- en cas de départ conflictuel, il faut aussi remplacer la clé GitHub ;
- un code court pourrait être deviné par force brute, d'où un minimum de 16 caractères.

**6. Le compte GitHub de l'association.** C'est la pièce maîtresse. Quelqu'un qui en prendrait le contrôle, ou qui aurait à la fois le code admin et le fichier chiffré, pourrait modifier l'appli elle-même : par exemple changer les adresses des CSAPA, ou ajouter du code qui détourne les saisies. Il faut :
- un compte au nom de l'association, pas sur l'adresse personnelle d'un salarié ;
- la double authentification activée ;
- des identifiants rangés par la direction ;
- vérifier de temps en temps la liste des destinataires.

**7. Pas d'identification de l'utilisateur côté équipe.** N'importe qui peut ouvrir l'appli et produire un PDF à l'en-tête du Bus. La garantie d'authenticité, c'est **l'adresse Outlook de l'expéditeur**, pas le PDF. Les CSAPA destinataires doivent le savoir.

**8. Hébergement par GitHub (Microsoft, États-Unis).** GitHub héberge le code de l'appli et les documents vierges, jamais de données patient.

## À faire valider

- Inscription du traitement au **registre RGPD** de l'association, et information des patients.
- Avis du **DPO** sur l'envoi par Outlook sans chiffrement et sur le cas de l'adresse Gmail.
- Vérification auprès de l'informaticien : chiffrement Microsoft 365 disponible ou non.
- Choix des admins, et des personnes qui détiennent le compte GitHub de l'association.
