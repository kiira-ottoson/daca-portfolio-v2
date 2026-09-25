-- Week 1 - SQL Basics
-- Müügiandmete uurimine
-- Tabel: sales
-- =======================================================

-- Põhilised küsimused:
-- 1. Mitu rida on, millised veerud ja andmed tabelis on?
-- 2. Millised poed on esindatud?
-- 3. Millised on suurimad ja väiksemad tehingud?
-- 4. Puuduvaid väärtuseid?
-- 5. Kui palju on korduvaid müügikirjeid?
-- ========================================================

-- Põhilised tulemused:
-- Sales tabelis on 15 234 rida (müügitehingut) ja 12 veergu.
-- Müügikanaliteks on online ja pood. Poed on Tallinn, Tartu, Pärnu.
-- Tehingute arv asukoha järgi: Tallinn 5704, online 5204, Tartu 2708, Pärnu 1618. See on huvitav leid: veebipood on peaaegu sama suur kui Tallinna pood.
-- Suurim tehing on 2170 EUR ja väikseim -1405. Negatiivseid tehinguid on kokku 305 (tagastused?). 0 väärtusega tehinguid ei ole.
-- Puuduvad väärtused: 1487 tehingul (~10%) puudub kliendi ID (registreerumata klient), 5204 tehingul puudub poe asukoht (online-ost).
-- Teistes olulistes veergudes puuduvaid väärtuseid ei ole.
-- 15 234 müügist 5116 on potentsiaalsed duplikaadid (korduv sale_id).
-- ===========================================================

-- 1. Mitu rida on tabelis. Näita esimesed 10 rida, et näha tabeli struktuuri
SELECT COUNT(*) AS ridade_arv FROM sales;
SELECT * FROM sales LIMIT 10; 

-- Filtreeri Tallinna kaupluse tehingud, uuemad eespool
SELECT * FROM sales    
WHERE store_location = 'Tallinn'    
ORDER BY sale_date DESC    
LIMIT 15; 

-- 2. Leia kõik unikaalsed müügikanalid, mis müügitabelis esinevad
SELECT DISTINCT channel 
FROM sales;

-- Ainult unikaalsed kanali ja poe asukoha kombinatsioone
SELECT DISTINCT channel, store_location
FROM sales;

-- Loe kokku tehingute arv iga kaupluse kohta:
SELECT store_location, COUNT(*) AS tehinguid
FROM sales
GROUP BY store_location
ORDER BY tehinguid DESC;

-- Leia tehingud, kus summa on üle 100 EUR JA kauplus on Tallinnas:
SELECT * FROM sales
WHERE total_price > 100 AND store_location = 'Tallinn'   
ORDER BY total_price DESC; 

-- 3. 10 suurimat tehingut
SELECT * FROM sales ORDER BY total_price DESC LIMIT 10;
-- 10 väikseimat tehingut (kas on 0 või negatiivseid?)
SELECT * FROM sales ORDER BY total_price ASC LIMIT 10;

-- Mitu tehingut on summaga 0 või alla selle?
SELECT COUNT(*) AS kahtlased_tehingud
FROM sales
WHERE total_price <= 0;

-- 4. Otsi NULL väärtusi olulistes veergudes. Mitu rida, kus kliendi id puudub?
SELECT 
  COUNT(*) - COUNT(customer_id) AS puudu_customer, -- registreerumata kliendi ost
  COUNT(*) - COUNT(sale_id)  AS puudu_sale,
  COUNT(*) - COUNT(invoice_id)  AS puudu_invoice, 
  COUNT(*) - COUNT(product_id)  AS puudu_product,
  COUNT(*) - COUNT(total_price)  AS puudu_total_price,
  COUNT(*) - COUNT(store_location)  AS puudu_location -- online poe puhul ongi asukoht puudu
FROM sales; 

-- 5. kui palju on korduvaid müügikirjeid?
SELECT
    COUNT(*) AS kokku,
    COUNT(DISTINCT sale_id) AS unikaalseid_müüke,
    COUNT(*) - COUNT(DISTINCT sale_id) AS korduvaid_müüke
FROM sales; 