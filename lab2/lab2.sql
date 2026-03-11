DROP TABLE IF EXISTS StoreLocations;

CREATE TABLE StoreLocations (
    Id SERIAL PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Address VARCHAR(255) NOT NULL,
    City VARCHAR(100) NOT NULL,
    IsOpen BOOLEAN NOT NULL DEFAULT TRUE,
    Rating NUMERIC(2, 1) NOT NULL,
    
    FullAddress TEXT GENERATED ALWAYS AS (Name || ' (' || City || ', ' || Address || ')') STORED,
    
    -- constraint - обмеження
    CONSTRAINT CHK_Rating CHECK (Rating >= 0 AND Rating <= 5),
    CONSTRAINT UQ_StoreNameCity UNIQUE (Name, City)
);

-- 1 запис
INSERT INTO StoreLocations (Name, Address, City, IsOpen, Rating)
VALUES ('Silpo Central', 'Khreshchatyk 27', 'Kyiv', TRUE, 4.8);

-- while цикл для заповнення
DO $$
DECLARE 
    n_count INT := 15;
    i INT := 1;
BEGIN
    WHILE i <= n_count LOOP
        INSERT INTO StoreLocations (Name, Address, City, IsOpen, Rating)
        VALUES (
            'Store_' || i, 
            'Street ' || i, 
            CASE 
                WHEN i % 3 = 0 THEN 'Kharkiv' 
                WHEN i % 3 = 1 THEN 'Kyiv' 
                ELSE 'Odesa' 
            END, 
            (i % 5 != 0), -- IsOpen
            (RANDOM() * 5)::NUMERIC(2, 1)
        );
        i := i + 1;
    END LOOP;
END $$;

/* різні запити */

-- 0. Дефолтна таблиця
SELECT * FROM StoreLocations;

-- 1. вибірка з аліасами
SELECT Name AS "Store Name", Rating, FullAddress FROM StoreLocations;

-- 2. фільтрація за допомогою BETWEEN
SELECT * FROM StoreLocations WHERE Rating BETWEEN 4.0 AND 5.0;

-- 3. оператор IN
SELECT * FROM StoreLocations WHERE City IN ('Kyiv', 'Kharkiv');

-- 4. шаблон LIKE
SELECT * FROM StoreLocations WHERE Name LIKE 'S%';

-- 5. перевірка на IS NOT NULL
SELECT * FROM StoreLocations WHERE IsOpen IS NOT NULL;

-- 6. AND, OR, NOT
SELECT * FROM StoreLocations WHERE (City = 'Kyiv' OR Rating > 4.5) AND NOT IsOpen = FALSE;

-- 7. ORDER BY (спочатку відкриті, потім за рейтингом)
SELECT * FROM StoreLocations ORDER BY IsOpen DESC, Rating DESC;

-- 8. обмеження кількості записів (LIMIT замість TOP у Postgres)
SELECT * FROM StoreLocations ORDER BY Rating DESC LIMIT 5;

-- 9. пропустити 5, взяти наступні 5 (OFFSET/FETCH)
SELECT * FROM StoreLocations ORDER BY Id OFFSET 5 ROWS FETCH NEXT 5 ROWS ONLY;

-- 10. пошук магазинів у конкретних містах з низьким рейтингом
SELECT * FROM StoreLocations WHERE City = 'Odesa' AND Rating < 3.5;

-- 11. закрити магазин за певним ID
UPDATE StoreLocations SET IsOpen = FALSE WHERE Id = 2;
SELECT * FROM StoreLocations;

-- 12. масове оновлення рейтингу для конкретного міста
UPDATE StoreLocations SET Rating = 5.0 WHERE City = 'Kyiv' AND Rating >= 4.5;
SELECT * FROM StoreLocations;

-- 13. оновлення назви через конкатенацію (||)
UPDATE StoreLocations SET Name = Name || ' (Closed)' WHERE IsOpen = FALSE;
SELECT * FROM StoreLocations;

-- 14. оновлення рейтингу для адрес що містять "Street 1"
UPDATE StoreLocations SET Rating = 1.0 WHERE Address LIKE 'Street 1%';
SELECT * FROM StoreLocations;

-- 15. скидання статусу (IS NULL)
UPDATE StoreLocations SET IsOpen = TRUE WHERE IsOpen IS NULL;
SELECT * FROM StoreLocations;

-- 16. видалення конкретного запису
DELETE FROM StoreLocations WHERE Id = 10;
SELECT * FROM StoreLocations;

-- 17. видалення всіх магазинів з критично низьким рейтингом
DELETE FROM StoreLocations WHERE Rating < 1.0;
SELECT * FROM StoreLocations;

-- 18. видалення запереченням (NOT IN)
DELETE FROM StoreLocations WHERE City NOT IN ('Kyiv', 'Odesa');
SELECT * FROM StoreLocations;

-- 19. видалення за декількома умовами
DELETE FROM StoreLocations WHERE IsOpen = FALSE AND Rating < 2.5;
SELECT * FROM StoreLocations;

-- 20. видалення всіх тестових записів створених циклом
DELETE FROM StoreLocations WHERE Name LIKE 'Store_%';
SELECT * FROM StoreLocations;

-- фінальна перевірка результату
SELECT * FROM StoreLocations;