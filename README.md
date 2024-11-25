# Projet de Gestion de Base de Données SQL
## Description du Projet
Ce projet consiste à créer une base de données pour gérer un système de commandes, avec des tables dédiées aux catégories, clients, commandes, détails des commandes, employés, fournisseurs et produits.  
L'objectif principal est de démontrer mes compétences en SQL à travers la création, la manipulation et l'interrogation des données à l'aide de requêtes complexes.
---

## Structure de la Base de Données
### Tables Créées
- **CATEGORIES** : Contient des informations sur les catégories de produits.
- **CLIENTS** : Stocke les informations des clients.
- **COMMANDES** : Gère les commandes passées par les clients.
- **DETAILS_COMMANDES** : Détails des produits dans chaque commande.
- **EMPLOYES** : Informations sur les employés.
- **FOURNISSEURS** : Détails des fournisseurs.
- **PRODUITS** : Informations sur les produits disponibles à la vente.
---

## Scripts SQL
Ce projet inclut plusieurs scripts SQL permettant de :
1. Créer les tables avec des contraintes appropriées.
2. Insérer des données dans chaque table.
3. Mettre à jour certaines données en fonction de conditions spécifiques.
4. Exécuter des requêtes complexes pour extraire des informations pertinentes.

## Exemples de Requêtes SQL
### 1. Sélection des Employés
SELECT * FROM EMPLOYES;

### 2. Employés Masculins avec Salaire Élevé
SELECT 
    NO_EMPLOYE,
    NOM, 
    PRENOM,        
    DATEDIFF(YEAR, DATE_NAISSANCE, GETDATE()) AS AGE,
    DATEDIFF(YEAR, DATE_EMBAUCHE, GETDATE()) AS ANCIENNETE
FROM 
    EMPLOYES
WHERE 
    TITRE = 'M.'
    AND (SALAIRE + COMMISSION) >= 8000
ORDER BY 
    ANCIENNETE DESC;

### 3. Produits en Bouteille
SELECT 
    REF_PRODUIT,
    NOM_PRODUIT,
    NO_FOURNISSEUR,
    UNITES_COMMANDEES,
    PRIX_UNITAIRE
FROM 
    PRODUITS
WHERE 
    UNITES_COMMANDEES IS NOT NULL
    AND UNITES_COMMANDEES > 0
    AND LOWER(QUANTITE) LIKE '%bouteille%'
    AND SUBSTRING(NOM_PRODUIT, 3, 1) IN ('t', 'T')
    AND NO_FOURNISSEUR IN (1, 2, 3)
    AND PRIX_UNITAIRE BETWEEN 70 AND 200;

### 4. Clients en France avec Montant Total des Commandes
SELECT 
    c.CODE_CLIENT,
    c.SOCIETE,
    c.TELEPHONE,
    ISNULL(SUM(dc.PRIX_UNITAIRE * dc.QUANTITE * (1 - dc.REMISE)), 0) AS montant_total,
    c.PAYS
FROM 
    CLIENTS c
LEFT JOIN 
    COMMANDES cmd ON c.CODE_CLIENT = cmd.CODE_CLIENT
LEFT JOIN 
    DETAILS_COMMANDES dc ON cmd.NO_COMMANDE = dc.NO_COMMANDE
WHERE 
    c.PAYS = 'France'
GROUP BY 
    c.CODE_CLIENT, c.SOCIETE, c.TELEPHONE, c.PAYS
ORDER BY 
    c.CODE_CLIENT;

## Conclusion
Ce projet illustre mes compétences en SQL, y compris la création de bases de données, la manipulation de données et l'écriture de requêtes complexes pour des analyses approfondies. Je suis enthousiaste à l'idée de continuer à développer mes compétences en SQL et d'explorer de nouveaux défis.

