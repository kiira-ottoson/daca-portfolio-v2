-- Week 2 - SQL Andmete puhastamine
-- Kliendiandmete puhastamine
-- Tabel: customers
-- NB! Töö toimub testkoopiaga
-- =========================================================

-- ENNE PUHASTAMIST
-- Põhilised küsimused:
-- 1. Leia duplikaatsed emailid
-- 2. Kas esineb puuduvaid klientinimesid
-- 3. Ebajärjekindlus linnanimedes
-- 4. Kas on puuduvaid kontaktandmeid

-- Põhilised tulemused:
-- 130 klienti on registreeritud korduva emailiga (duplikaatread).
-- Nimed on olemas kõigil klientidel. Nimede kirjapilt on ebaühtlane (nt Ago Rand, AGO Rand).
-- Linnanimedes on 54 erinevat väärtust sest sama linn on kirjutatud mitmel viisil (nt tallinn, TALLINN)
-- Tel nr on kõikidel klientidel, kuid 380 kliendil puudub email
-- ==========================================================

-- 5. PUHASTAMINE ja TULEMUSED
-- Ühtlustasin linnanimede kirjapildi. Tulemus 12 erinevat linna.
-- Ühtlustasin ees- ja perenimede kirjapildi.
-- Korduvalt registreeritud kliente (130 duplikaatrida) ei kustutatud. Eelnevalt vaja kontrollida kas duplikaadid on seotud mõne tellimusega.
-- ===========================================================

-- Testkoopia loomine
CREATE TABLE customers_test AS SELECT * FROM customers;
SELECT COUNT(*) AS ridade_arv FROM customers_test;

-- 1. Leia duplikaatsed emailid. NULL-id jäetud sisse: 
-- esimene rida (NULL, 380) näitab puuduvaid e-maile
SELECT email, COUNT(*) AS koopiate_arv
FROM customers_test
GROUP BY email
HAVING COUNT(*) > 1
ORDER BY koopiate_arv DESC;

-- Näita duplikaatseid emaili ridasid
SELECT *
FROM customers_test
WHERE email IN (
    SELECT email
    FROM customers_test
    GROUP BY email
    HAVING COUNT(*) > 1
)
ORDER BY email;

-- Kui palju on korduvaid emaile
SELECT
  COUNT(email) - COUNT(DISTINCT email) AS korduvaid_emaile
FROM customers_test;

-- 2. Leia puuduvad nimed
SELECT
    COUNT(*) FILTER (WHERE first_name IS NULL OR first_name = '') AS null_eesnimi,
    COUNT(*) FILTER (WHERE last_name IS NULL OR last_name = '') AS null_perenimi
FROM customers_test;

-- 3. Kontrolli linnade nimekujusid
SELECT city, COUNT(*) AS arv
FROM customers_test
GROUP BY city
ORDER BY city;

-- Mitu erinevat linnanime väärtust on?
SELECT COUNT(DISTINCT city) AS erinevaid_linnanimesid
FROM customers_test;

-- 4. Kas on puuduvaid kontaktandmeid
SELECT
    COUNT(*) FILTER (WHERE phone IS NULL OR phone = '') AS null_telefon,
    COUNT(*) FILTER (WHERE email IS NULL OR email = '') AS null_email
FROM customers_test;

-- 5. Ühtlusta linnanimed INITCAP + TRIM abil
-- Kontroll: jooksuta uuesti päring 3
UPDATE customers_test
SET city = INITCAP(TRIM(city))
WHERE city != INITCAP(TRIM(city));

-- Ühtlusta ees- ja perenimede kirjapilt
UPDATE customers_test
SET first_name = INITCAP(TRIM(first_name)),
    last_name = INITCAP(TRIM(last_name))
WHERE first_name != INITCAP(TRIM(first_name))
   OR last_name != INITCAP(TRIM(last_name));

