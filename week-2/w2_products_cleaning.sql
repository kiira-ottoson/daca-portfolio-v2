-- Week 2 - SQL Andmete puhastamine
-- Tooteandmete puhastamine
-- Tabel: products
-- NB! Töö toimub testkoopiaga
-- =========================================================

-- ENNE PUHASTAMIST
-- Põhilised küsimused:
-- 1. Kas on korduvaid tootenimesid (duplikaadid)?
-- 2. NULL väärtused (tootenimi, kategooria, omahind, jaehind)?
-- 3. Kas on ebarealistlikke hindu?
-- 4. Kategooriate kirjapildi järjekindlus (nt Shoes, SHOES, jalanõud)?

-- Põhilised tulemused:
-- 12 toodet on kahes korduses. Enne puhastamist vaja selgitada, kas duplikaadid on seotud ostudega.
-- Puuduvaid väärtuseid olulistes väljades ei ole.
-- Toodete hinnad (retail_price) jäävad vahemikku 13 - 434 eur. 0 eur tooteid ei ole.
-- Kategooriate (5 kategooriat) kirjapilt on ühtlane. Soovitame muuta "jalanõusid" --> "jalanõud".
-- ==========================================================

-- 5. PUHASTAMINE ja TULEMUSED
-- Muudetud kategooria nimetus "jalanõusid" --> "jalanõud"
-- Korduvaid tooteid ei kustutatud. Enne vaja kontrollida, kas seotud tellimustega.
-- ===========================================================

-- Testkoopia loomine
CREATE TABLE products_test AS SELECT * FROM products;
SELECT COUNT(*) AS ridade_arv FROM products_test;

-- 1. Kas on korduvaid tootenimesid
SELECT product_name, COUNT(*) AS koopiate_arv
FROM products_test
GROUP BY product_name
HAVING COUNT(*) > 1
ORDER BY koopiate_arv DESC;

-- Näita korduvad tooted
SELECT *
FROM products_test
WHERE product_name IN (
    SELECT product_name
    FROM products_test
    GROUP BY product_name
    HAVING COUNT(*) > 1
)
ORDER BY product_name, product_id;

-- 2. Kas on NULL väärtuseid kriitilistes väljades
SELECT
    COUNT(*) FILTER (WHERE product_name IS NULL OR product_name = '') AS null_nimi,
    COUNT(*) FILTER (WHERE category IS NULL OR category = '') AS null_kategooria,
    COUNT(*) FILTER (WHERE retail_price IS NULL) AS null_jaehind,
    COUNT(*) FILTER (WHERE cost_price IS NULL) AS null_omahind
FROM products_test;

-- 3. Kas on ebarealistlikke hindu
SELECT 
    MIN(retail_price) AS min_hind,
    MAX(retail_price) AS max_hind    
FROM products_test;

SELECT COUNT(*) 
FROM products_test
WHERE retail_price = 0;

-- 4. Kontrolli kategooriate kirjapildi järjekindlust
SELECT category, COUNT(*) AS arv
FROM products_test
GROUP BY category
ORDER BY category;

-- 5. Muuda kategooria nimetust
UPDATE products_test
SET category = 'jalanõud'
WHERE category = 'jalanõusid';