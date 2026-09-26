-- Week 1 - SQL Basics
-- Tooteandmete uurimine
-- Tabel: products
-- =======================================================

-- Põhilised küsimused:
-- 1. Mitu toodet on?
-- 2. Millised on kategooriad?
-- 3. Mis on toodete hinnavahemik?
-- 4. Kas on puuduvaid andmeid?
-- ========================================================

-- Põhilised tulemused:
-- Products tabelis on 362 rida (toodet) ja 9 veergu.
-- 350 unikaalset tootenime. Sama nimi ei tähenda tingimata duplikaati
-- (võib olla erinev kategooria/toode), seega esmases auditis edasi ei uurinud.
-- 362 toodet kuuluvad 5 kategooriasse ja 22 alamkategooriasse.
-- Odavaima toote jaehind on 13,5 eur ja kalleima 434 eur.
-- Puuduvaid väärtuseid olulistes väljades ei ole
-- ===========================================================

-- 1. Mitu rida on tabelis. Näita esimesed 10 rida, et näha tabeli struktuuri
SELECT COUNT(*) AS ridade_arv FROM products;
SELECT * FROM products LIMIT 10;

-- 2. Mitu kategooriat on?
SELECT DISTINCT category
FROM products;

-- Toodete, kategooriate ja alamkategooriate arv
SELECT
  COUNT(*) AS tooteid,
  COUNT(DISTINCT category) AS kategooriaid,
  COUNT(DISTINCT subcategory) AS alamkategooriaid
FROM products;

-- Mitu toodet on igas kategoorias?
SELECT category, COUNT(*) AS toodete_arv
FROM products
GROUP BY category
ORDER BY toodete_arv DESC;

-- Kas tooted korduvad?
SELECT
  COUNT(*) AS ridu_kokku,
  COUNT(DISTINCT product_id) AS unikaalseid_id,
  COUNT(DISTINCT product_name) AS unikaalseid_nimesid
FROM products;

-- 3. Leia odavaim ja kalleim toode
SELECT 
    MIN(retail_price) AS min_hind,
    MAX(retail_price) AS max_hind    
FROM products;

-- 4. Otsi puuduvaid väärtuseid olulistes väljades
SELECT 
  COUNT(*) - COUNT(product_name) AS puudu_tootenimi, 
  COUNT(*) - COUNT(category)  AS puudu_kategooria,
  COUNT(*) - COUNT(subcategory)  AS puudu_alamkategooria, 
  COUNT(*) - COUNT(supplier)  AS puudu_tarnija,
  COUNT(*) - COUNT(cost_price)  AS puudu_omahind,
  COUNT(*) - COUNT(retail_price)  AS puudu_jaehind 
FROM products; 

