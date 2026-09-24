-- Minu esimene UrbanStyle päring
-- Kuupäev: 20.06.2026

-- Loo meeskonnaliikmete tabel
CREATE TABLE IF NOT EXISTS team_members (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    role VARCHAR(100),
    iseloomujoon TEXT,
    joined_at DATE DEFAULT CURRENT_DATE
);

-- Lisa oma andmed
INSERT INTO team_members (name, role)
VALUES ('Kiira Ottoson', 'Andmeanalüütik');

-- Vaata tulemust
SELECT * FROM team_members ORDER BY joined_at;

-- Lisa teised liikmed
INSERT INTO team_members (name, role, iseloomujoon)
VALUES
  ('Toomas Kask', 'IT Director', 'Skeptiline, tahab dokumentatsiooni ja korda'),
  ('Anna', 'Marketing Lead', 'Kiire, tahab visuaalseid vastuseid kohe'),
  ('Kristi', 'CEO', 'Hõivatud, vajab 30-sekundilisi dashboarde'),
  ('Marko', 'Product Manager', 'Uudishimulik, tahab sügavat kliendiarusaama');

  -- Uuenda tabelit 
UPDATE team_members
SET iseloomujoon = 'Ei kiirusta ega usalda pimesi — küsib täpsustusi, tahab mehhanismi mõista'
WHERE name = 'Kiira Ottoson';