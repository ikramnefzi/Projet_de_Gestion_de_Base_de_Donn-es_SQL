SELECT * FROM EMPLOYES;

-- Afficher par ordre d�croissant d'anciennet� les employ�s de sexe masculin dont le salaire net (salaire + commission) 
-- est sup�rieur ou �gal � 8000. Le tableau r�sultant doit inclure les colonnes suivantes : 
-- Num�ro d'employ�, Pr�nom et Nom (en utilisant LPAD ou RPAD pour le formatage), �ge et Anciennet�.

SELECT 
    NO_EMPLOYE,
    NOM, 
    PRENOM,        
    DATEDIFF(YEAR, DATE_NAISSANCE, GETDATE()) AS AGE,  -- Calcul de l'�ge
    DATEDIFF(YEAR, DATE_EMBAUCHE, GETDATE()) AS ANCIENNETE  -- Calcul de l'anciennet�
FROM 
    EMPLOYES
WHERE 
    TITRE = 'M.'
    AND (salaire + commission) >= 8000
ORDER BY 
    anciennete DESC;

-- Affichez les produits qui r�pondent aux crit�res suivants : (C1) la quantit� est conditionn�e en bouteille(s), (C2) 
-- le troisi�me caract�re du nom du produit est � t � ou � T �, (C3) fourni par les fournisseurs 1, 2 ou 3, (C4) le prix unitaire 
-- est compris entre 70 et 200 et (C5) les unit�s command�es sont sp�cifi�es (non nulles). Le tableau r�sultant doit inclure les colonnes 
-- suivantes : num�ro de produit, nom du produit, num�ro de fournisseur, unit�s command�es et prix unitaire.

SELECT * FROM PRODUITS;

SELECT 
    REF_PRODUIT,               -- Num�ro de produit
    NOM_PRODUIT,                  -- Nom du produit
    NO_FOURNISSEUR,           -- Num�ro de fournisseur
    UNITES_COMMANDEES,              -- Unit�s command�es
    PRIX_UNITAIRE                 -- Prix unitaire
FROM 
    PRODUITS                    -- Nom de la table des produits
WHERE 
    UNITES_COMMANDEES IS NOT NULL AND  -- Crit�re C5 : unit�s command�es sp�cifi�es
    UNITES_COMMANDEES > 0 AND           -- S'assurer que les unit�s command�es sont non nulles
    lower(QUANTITE)LIKE '%bouteille%' AND  -- Crit�re C1 : quantit� conditionn�e en bouteilles
    SUBSTRING(NOM_PRODUIT, 3, 1) IN ('t', 'T') AND  -- Crit�re C2 : le troisi�me caract�re est 't' ou 'T'
    NO_FOURNISSEUR IN (1, 2, 3) AND  -- Crit�re C3 : fourni par les fournisseurs 1, 2 ou 3
    PRIX_UNITAIRE BETWEEN 70 AND 200;   -- Crit�re C4 : prix unitaire entre 70 et 200
	
-- Affichez les clients qui r�sident dans la m�me r�gion que le fournisseur 1, c'est-�-dire qu'ils partagent le m�me pays, 
-- la m�me ville et les trois derniers chiffres du code postal. La requ�te doit utiliser une seule sous-requ�te. La table r�sultante 
-- doit inclure toutes les colonnes de la table client.

SELECT * FROM CLIENTS;

SELECT *
FROM CLIENTS c
WHERE (c.PAYS = (SELECT pays FROM FOURNISSEURS WHERE NO_FOURNISSEUR = 1) AND
       c.VILLE = (SELECT ville FROM FOURNISSEURS WHERE NO_FOURNISSEUR = 1) AND
       RIGHT(c.CODE_POSTAL, 3) = RIGHT((SELECT CODE_POSTAL FROM FOURNISSEURS WHERE NO_FOURNISSEUR = 1), 3));

-- Pour chaque num�ro de commande compris entre 10998 et 11003, proc�dez comme suit :  
-- Affichez le nouveau taux de remise, qui doit �tre de 0 % si le montant total de la commande avant remise (prix unitaire * quantit�) 
-- est compris entre 0 et 2000, 5 % s'il est compris entre 2001 et 10000, 10 % s'il est compris entre 10001 et 40000, 15 % s'il est compris 
--entre 40001 et 80000 et 20 % dans le cas contraire.
-- Affichez le message � appliquer l'ancien taux de remise � si le num�ro de commande est compris entre 10000 et 10999 et � appliquer
-- le nouveau taux de remise � dans le cas contraire. Le tableau r�sultant doit afficher les colonnes : num�ro de commande, nouveau taux 
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

-- Affichez les fournisseurs de boissons. Le tableau obtenu doit afficher les colonnes : num�ro de fournisseur, soci�t�, adresse 
-- et num�ro de t�l�phone.

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
    lower(p.QUANTITE)LIKE '%bouteille%';  -- Assurez-vous que 'categorie' est la colonne appropri�e pour filtrer les boissons

-- Affichez les clients de Berlin qui ont command� au maximum 1 (0 ou 1) produit de dessert. 
-- Le tableau r�sultant doit afficher la colonne : code client.

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

-- Affichez les clients r�sidant en France et le montant total des commandes qu'ils ont pass�es chaque lundi en avril 1998 
-- (en tenant compte des clients qui n'ont pas encore pass� de commande). Le tableau obtenu doit afficher les colonnes suivantes : 
-- num�ro de client, nom de l'entreprise, num�ro de t�l�phone, montant total et pays.

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


-- Affichez les clients qui ont command� tous les produits. Le tableau obtenu doit afficher les colonnes : 
-- code client, nom de l'entreprise et num�ro de t�l�phone.

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

--  Affichez pour chaque client de France le nombre de commandes qu'il a pass�es. Le tableau obtenu doit afficher les colonnes : 
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

-- Affichez le nombre de commandes pass�es en 1996, le nombre de commandes pass�es en 1997 et la diff�rence entre ces deux nombres. 
-- Le tableau obtenu doit afficher les colonnes suivantes : commandes en 1996, commandes en 1997 et diff�rence.

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

