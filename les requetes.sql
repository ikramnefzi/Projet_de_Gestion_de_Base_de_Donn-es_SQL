SELECT * FROM EMPLOYES;

-- Afficher par ordre décroissant d'ancienneté les employés de sexe masculin dont le salaire net (salaire + commission) 
-- est supérieur ou égal à 8000. Le tableau résultant doit inclure les colonnes suivantes : 
-- Numéro d'employé, Prénom et Nom (en utilisant LPAD ou RPAD pour le formatage), Âge et Ancienneté.

SELECT 
    NO_EMPLOYE,
    NOM, 
    PRENOM,        
    DATEDIFF(YEAR, DATE_NAISSANCE, GETDATE()) AS AGE,  -- Calcul de l'âge
    DATEDIFF(YEAR, DATE_EMBAUCHE, GETDATE()) AS ANCIENNETE  -- Calcul de l'ancienneté
FROM 
    EMPLOYES
WHERE 
    TITRE = 'M.'
    AND (salaire + commission) >= 8000
ORDER BY 
    anciennete DESC;

-- Affichez les produits qui répondent aux critères suivants : (C1) la quantité est conditionnée en bouteille(s), (C2) 
-- le troisième caractère du nom du produit est « t » ou « T », (C3) fourni par les fournisseurs 1, 2 ou 3, (C4) le prix unitaire 
-- est compris entre 70 et 200 et (C5) les unités commandées sont spécifiées (non nulles). Le tableau résultant doit inclure les colonnes 
-- suivantes : numéro de produit, nom du produit, numéro de fournisseur, unités commandées et prix unitaire.

SELECT * FROM PRODUITS;

SELECT 
    REF_PRODUIT,               -- Numéro de produit
    NOM_PRODUIT,                  -- Nom du produit
    NO_FOURNISSEUR,           -- Numéro de fournisseur
    UNITES_COMMANDEES,              -- Unités commandées
    PRIX_UNITAIRE                 -- Prix unitaire
FROM 
    PRODUITS                    -- Nom de la table des produits
WHERE 
    UNITES_COMMANDEES IS NOT NULL AND  -- Critère C5 : unités commandées spécifiées
    UNITES_COMMANDEES > 0 AND           -- S'assurer que les unités commandées sont non nulles
    lower(QUANTITE)LIKE '%bouteille%' AND  -- Critère C1 : quantité conditionnée en bouteilles
    SUBSTRING(NOM_PRODUIT, 3, 1) IN ('t', 'T') AND  -- Critère C2 : le troisième caractère est 't' ou 'T'
    NO_FOURNISSEUR IN (1, 2, 3) AND  -- Critère C3 : fourni par les fournisseurs 1, 2 ou 3
    PRIX_UNITAIRE BETWEEN 70 AND 200;   -- Critère C4 : prix unitaire entre 70 et 200
	
-- Affichez les clients qui résident dans la même région que le fournisseur 1, c'est-à-dire qu'ils partagent le même pays, 
-- la même ville et les trois derniers chiffres du code postal. La requête doit utiliser une seule sous-requête. La table résultante 
-- doit inclure toutes les colonnes de la table client.

SELECT * FROM CLIENTS;

SELECT *
FROM CLIENTS c
WHERE (c.PAYS = (SELECT pays FROM FOURNISSEURS WHERE NO_FOURNISSEUR = 1) AND
       c.VILLE = (SELECT ville FROM FOURNISSEURS WHERE NO_FOURNISSEUR = 1) AND
       RIGHT(c.CODE_POSTAL, 3) = RIGHT((SELECT CODE_POSTAL FROM FOURNISSEURS WHERE NO_FOURNISSEUR = 1), 3));

-- Pour chaque numéro de commande compris entre 10998 et 11003, procédez comme suit :  
-- Affichez le nouveau taux de remise, qui doit être de 0 % si le montant total de la commande avant remise (prix unitaire * quantité) 
-- est compris entre 0 et 2000, 5 % s'il est compris entre 2001 et 10000, 10 % s'il est compris entre 10001 et 40000, 15 % s'il est compris 
--entre 40001 et 80000 et 20 % dans le cas contraire.
-- Affichez le message « appliquer l'ancien taux de remise » si le numéro de commande est compris entre 10000 et 10999 et « appliquer
-- le nouveau taux de remise » dans le cas contraire. Le tableau résultant doit afficher les colonnes : numéro de commande, nouveau taux 
-- de remise et note d'application du taux de remise.

SELECT * FROM DETAILS_COMMANDES;
SELECT * FROM COMMANDES;

SELECT 
    c.NO_COMMANDE,
    CASE 
        WHEN (d.PRIX_UNITAIRE * d.QUANTITE) BETWEEN 0 AND 2000 THEN 0
        WHEN (d.PRIX_UNITAIRE * d.QUANTITE) BETWEEN 2001 AND 10000 THEN 5
        WHEN (d.PRIX_UNITAIRE * d.QUANTITE) BETWEEN 10001 AND 40000 THEN 10
        WHEN (d.PRIX_UNITAIRE * d.QUANTITE) BETWEEN 40001 AND 80000 THEN 15
        ELSE 20
    END AS nouveau_taux_remise,
    CASE 
        WHEN c.NO_COMMANDE BETWEEN 10000 AND 10999 THEN 'appliquer l ancien taux de remise'
        ELSE 'appliquer le nouveau taux de remise'
    END AS note_application
FROM 
    COMMANDES c
JOIN 
    DETAILS_COMMANDES d ON c.NO_COMMANDE = d.NO_COMMANDE
WHERE 
    c.NO_COMMANDE BETWEEN 10998 AND 11003;

-- Affichez les fournisseurs de boissons. Le tableau obtenu doit afficher les colonnes : numéro de fournisseur, société, adresse 
-- et numéro de téléphone.

SELECT * FROM FOURNISSEURS;
SELECT * FROM PRODUITS;

SELECT 
    f.NO_FOURNISSEUR,
    f.SOCIETE,
    f.ADRESSE,
    f.TELEPHONE
FROM 
    FOURNISSEURS f
JOIN 
    PRODUITS p ON f.NO_FOURNISSEUR = p.NO_FOURNISSEUR
WHERE 
    lower(p.QUANTITE)LIKE '%bouteille%';  -- Assurez-vous que 'categorie' est la colonne appropriée pour filtrer les boissons

-- Affichez les clients de Berlin qui ont commandé au maximum 1 (0 ou 1) produit de dessert. 
-- Le tableau résultant doit afficher la colonne : code client.

SELECT * FROM CLIENTS;
SELECT * FROM PRODUITS;
SELECT * FROM COMMANDES;
SELECT * FROM CATEGORIES;

SELECT 
    c.CODE_CLIENT
FROM 
    CLIENTS c
JOIN 
    COMMANDES cmd ON c.CODE_CLIENT = cmd.CODE_CLIENT
JOIN 
    DETAILS_COMMANDES dc ON cmd.NO_COMMANDE = dc.NO_COMMANDE
JOIN 
    PRODUITS p ON dc.REF_PRODUIT = p.REF_PRODUIT
JOIN 
    CATEGORIES cat ON p.CODE_CATEGORIE = cat.CODE_CATEGORIE
WHERE 
    c.VILLE = 'Berlin'
    AND cat.NOM_CATEGORIE = 'Desserts'
GROUP BY 
    c.CODE_CLIENT
HAVING 
    COUNT(dc.REF_PRODUIT) <= 1;

-- Affichez les clients résidant en France et le montant total des commandes qu'ils ont passées chaque lundi en avril 1998 
-- (en tenant compte des clients qui n'ont pas encore passé de commande). Le tableau obtenu doit afficher les colonnes suivantes : 
-- numéro de client, nom de l'entreprise, numéro de téléphone, montant total et pays.

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
    AND (cmd.DATE_COMMANDE IS NULL OR 
        (cmd.DATE_COMMANDE BETWEEN '1998-04-01' AND '1998-04-30' 
         AND DATENAME(WEEKDAY, cmd.DATE_COMMANDE) = 'Monday'))
GROUP BY 
    c.CODE_CLIENT,
    c.SOCIETE,
    c.TELEPHONE,
    c.PAYS
ORDER BY 
    c.CODE_CLIENT;


-- Affichez les clients qui ont commandé tous les produits. Le tableau obtenu doit afficher les colonnes : 
-- code client, nom de l'entreprise et numéro de téléphone.

SELECT 
    c.CODE_CLIENT,
    c.SOCIETE,
    c.TELEPHONE
FROM 
    CLIENTS c
JOIN 
    COMMANDES cmd ON c.CODE_CLIENT = cmd.CODE_CLIENT
JOIN 
    DETAILS_COMMANDES dc ON cmd.NO_COMMANDE = dc.NO_COMMANDE
JOIN 
    PRODUITS p ON dc.REF_PRODUIT = p.REF_PRODUIT
GROUP BY 
    c.CODE_CLIENT, c.SOCIETE, c.TELEPHONE
HAVING 
    COUNT(DISTINCT p.REF_PRODUIT) = (SELECT COUNT(REF_PRODUIT) FROM PRODUITS)
ORDER BY 
    c.CODE_CLIENT;

--  Affichez pour chaque client de France le nombre de commandes qu'il a passées. Le tableau obtenu doit afficher les colonnes : 
-- code client et nombre de commandes.

SELECT 
    c.CODE_CLIENT,
    COUNT(cmd.NO_COMMANDE) AS NOMBRE_COMMANDES
FROM 
    CLIENTS c
LEFT JOIN 
    COMMANDES cmd ON c.CODE_CLIENT = cmd.CODE_CLIENT
WHERE 
    c.PAYS = 'France'
GROUP BY 
    c.CODE_CLIENT
ORDER BY 
    NOMBRE_COMMANDES DESC;

-- Affichez le nombre de commandes passées en 1996, le nombre de commandes passées en 1997 et la différence entre ces deux nombres. 
-- Le tableau obtenu doit afficher les colonnes suivantes : commandes en 1996, commandes en 1997 et différence.

SELECT 
    (SELECT COUNT(*) 
     FROM COMMANDES 
     WHERE YEAR(DATE_COMMANDE) = 1996) AS COMMANDES_1996,
    
    (SELECT COUNT(*) 
     FROM COMMANDES 
     WHERE YEAR(DATE_COMMANDE) = 1997) AS COMMANDES_1997,
    
    ( (SELECT COUNT(*) 
       FROM COMMANDES 
       WHERE YEAR(DATE_COMMANDE) = 1997)
      - 
      (SELECT COUNT(*) 
       FROM COMMANDES 
       WHERE YEAR(DATE_COMMANDE) = 1996)
    ) AS DIFFERENCE

