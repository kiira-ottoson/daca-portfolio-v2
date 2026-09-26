-- Week 1 - SQL Basics
-- Kliendiandmete uurimine
-- Tabel: customers
-- =======================================================

-- Põhilised küsimused:
-- 1. Mitu klienti on?
-- 2. Millistest linnadest kliendid on?
-- 3. Millal kliendid registreerusid?
-- 4. Kas on puuduvaid andmeid (nimi, e-mail)
-- 5. Kas e-mailid korduvad?
-- ========================================================

-- Põhilised tulemused:
-- Customers tabelis on 3150 rida (registreerunud klienti) ja 9 veergu.
-- Linnanimedes on 54 erinevat väärtust sest sama linn on kirjutatud mitmel viisil (nt. 'TALLINN', 'tallinn' 'Tallinn',' Tallinn' ). 
-- Enne asukoha analüüsi on vaja linnanimede kirjapilt ühtlustada.
-- Vanim registreerumine 2020-01-02 ja uusim registreerumine 2025-02-27. Viimase 6 kuu jooksul (2024-08-27 kuni 2025-02-27) on registreerunud 331 uut klienti.
-- Nimed on olemas kõigil klientidel. 380 kliendil puudub e-mail.
-- 130 klienti on registreeritud korduva e-mailiga — need on potentsiaalsed duplikaadid. 
-- Enne puhastamist tuleb kokku leppida, mis defineerib unikaalse kliendi (e-mail? e-mail + nimi?).
-- ===========================================================

-- 1. Mitu klienti on kokku? Näita esimesed 10 rida.
SELECT COUNT (*) as kliente_kokku FROM customers;
SELECT * FROM customers LIMIT 10; 

-- 2. Millistest linnadest kliendid on?
SELECT DISTINCT city FROM customers 
ORDER BY city ASC;

-- Mitu erinevat linnanime väärtust on?
SELECT COUNT(DISTINCT city) AS erinevaid_linnanimesid
FROM customers;

-- Milliseid "Tallinna" erinevaid kirjapilte üldse eksisteerib?
SELECT '[' || city || ']' AS linn,
    COUNT(*) AS klientide_arv
FROM customers
WHERE city ILIKE '%tallinn%' -- ILIKE ei tee vahet suur- ja väiketähtedel
GROUP BY city
ORDER BY klientide_arv DESC;

-- 3. Vanim ja uusim registreerimine
SELECT 
    MIN(registration_date) AS vanim,
    MAX(registration_date) AS uusim    
FROM customers;

  -- Viimase 6 kuu jooksul registreerunud klientide arv
SELECT
  COUNT(*) AS registreerunuid
FROM customers
WHERE registration_date >= '2024-08-27';

-- Viimase 6 kuu jooksul registreerunud kliendid
SELECT *
FROM customers
WHERE registration_date >= '2024-08-27'
ORDER BY registration_date DESC;

-- 4. Mitmel kliendil puudub ees- või perenimi
SELECT COUNT(*) AS puuduva_nimega
FROM customers
WHERE first_name IS NULL OR last_name IS NULL;

-- Mitmel kliendil puudub e-mail
SELECT COUNT(*) AS puuduv_email
FROM customers
WHERE email IS NULL;

-- 5. Kas on korduvaid e-maile? (NULL-id eraldi, et need ei segaks)
SELECT
  COUNT(*) AS kliente_kokku,
  COUNT(email) AS emailiga,
  COUNT(*) - COUNT(email) AS puuduv_email,
  COUNT(DISTINCT email) AS unikaalseid_emaile,
  COUNT(email) - COUNT(DISTINCT email) AS korduvaid_emaile
FROM customers;