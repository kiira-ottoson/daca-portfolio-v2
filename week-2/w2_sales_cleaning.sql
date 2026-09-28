-- Week 2 - SQL Andmete puhastamine
-- Müügiandmete puhastamine
-- Tabel: sales
-- NB! Töö toimub testkoopiaga
-- =========================================================

-- ENNE PUHASTAMIST
-- Põhilised küsimused:
-- 1. Millised tellimused (arved) korduvad?
-- 2. Kas kriitilistes väljades esineb NULL väärtuseid (kliendi id, müügikuupäev, müügisumma).
-- 3. Kontrolli kas on tuleviku kuupäevi. Antud kontekstis andmed lõppevad veebruaris 2025.

-- Põhilised tulemused:
-- Tabelis on 15 234 rida (tellimust). 4013 arvet korduvad (enamasti 2 koopiat, max 6), 
-- kokku 5116 duplikaatrida.
-- 1487 (~10%) tellimusel puudub kliendi id (külalisost, mitte andmeviga).
-- Kuupäev ja müügisumma on olemas kõigil tellimustel.
-- 50 tellimust jäävad väljapoole andmeperioodi.
-- ==========================================================

-- 4. PUHASTAMINE ja TULEMUSED
-- Duplikaatridadel on sama invoice_id. Rea id on unikaalne tunnus: 
-- alles hoiame iga arve väikseima rea id-ga rea, ülejäänud on duplikaadid.
-- Kustutati 5116 duplikaatrida, alles jäi 10 118 rida (unikaalset müügitehingut).
-- Nendest 9130 on registreeritud klient ja 988 külalisost (kliendi id puudub).
-- 32 tellimust on väljaspool andmeperioodi (tulevikus).
-- ===========================================================

-- Testkoopia loomine
CREATE TABLE sales_test AS SELECT * FROM sales;
-- NB: `CREATE TABLE ... AS SELECT` ei pärandata alati `id`-d. lisab `id` AINULT siis, kui see puudub.
ALTER TABLE sales_test ADD COLUMN IF NOT EXISTS id SERIAL;
-- Kontrolli ridade arvu
SELECT COUNT(*) AS ridade_arv FROM sales_test;

-- 1. Leia duplikaadid - millised tellimused (invoice_id) korduvad
SELECT invoice_id, COUNT(*) AS koopiate_arv
FROM sales_test
GROUP BY invoice_id
HAVING COUNT(*) > 1
ORDER BY koopiate_arv DESC;

-- Näita duplikaatseid arveridu
SELECT *
FROM sales_test
WHERE invoice_id IN (
    SELECT invoice_id
    FROM sales_test
    GROUP BY invoice_id
    HAVING COUNT(*) > 1
)
ORDER BY invoice_id, id;

-- Kui palju on duplikaatseid ridu
SELECT COUNT(*) AS duplikaat_read
FROM sales_test
WHERE id NOT IN (           
    SELECT MIN(id)
    FROM sales_test
    GROUP BY invoice_id
);

-- Näita koopiate arvu
SELECT koopiate_arv, COUNT(*) AS arveid
FROM (
    SELECT invoice_id, COUNT(*) AS koopiate_arv
    FROM sales_test
    GROUP BY invoice_id
    HAVING COUNT(*) > 1
) AS korduvad
GROUP BY koopiate_arv
ORDER BY koopiate_arv;

-- 2. Leia NULL väärtused kriitilistes väljades
-- (customer_id, sale_date, total_price)
SELECT
    COUNT(*) FILTER (WHERE customer_id IS NULL) AS null_customer_id,
    COUNT(*) FILTER (WHERE sale_date IS NULL) AS null_sale_date,
    COUNT(*) FILTER (WHERE total_price IS NULL) AS null_total_price
FROM sales_test;

-- 3. Kontrolli kas on tuleviku kuupäevi. 
SELECT COUNT(*) AS tuleviku_kuupaevad
FROM sales_test
WHERE sale_date > '2025-02-28';

-- 4. Duplikaatide kustutamine (jäta alles ainult esimene rida iga invoice_id kohta)
DELETE FROM sales_test
WHERE id NOT IN (
    SELECT MIN(id)
    FROM sales_test
    GROUP BY invoice_id);

-- Kui palju on registreeritud klientide oste ja kui palju külalisoste
SELECT
    CASE WHEN COALESCE(customer_id, -1) = -1
         THEN 'Külalisost'
         ELSE 'Registreeritud klient'
    END AS ostja_tyyp,
    COUNT(*) AS ridu
FROM sales_test
GROUP BY ostja_tyyp;

-- Kontroll: ridu pärast duplikaatide kustutamist
SELECT COUNT(*) AS ridu_parast FROM sales_test;

-- Tuleviku kuupäevad pärast kustutamist
SELECT COUNT(*) AS tuleviku_kuupaevad
FROM sales_test
WHERE sale_date > '2025-02-28';



