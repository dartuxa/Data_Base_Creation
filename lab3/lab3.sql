-- створення історії для сейва видалень
CREATE table if not exists StoreLocations_History (
    HistoryId SERIAL PRIMARY KEY,
    OriginalId INT,
    Name VARCHAR(100),
    City VARCHAR(100),
    ActionType VARCHAR(20), -- 'DELETED' або 'ARCHIVED'
    DeletedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- трігер збереження перед видаленням
CREATE OR REPLACE FUNCTION func_archive_store()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO StoreLocations_History (OriginalId, Name, City, ActionType)
    VALUES (OLD.Id, OLD.Name, OLD.City, 'DELETED');
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

-- створення трігера
CREATE TRIGGER trg_on_delete_store
BEFORE DELETE ON StoreLocations
FOR EACH ROW
EXECUTE FUNCTION func_archive_store();

-- View лише активні з високим рейтингом
CREATE OR REPLACE VIEW View_TopActiveStores AS
SELECT Name, City, Rating, FullAddress
FROM StoreLocations
WHERE IsOpen = TRUE AND Rating >= 4.0;

-- скалярна функція середній рейтинг по місту
CREATE OR REPLACE FUNCTION fn_GetAvgRatingByCity(city_name VARCHAR)
RETURNS NUMERIC(2,1) AS $$
DECLARE
    avg_res NUMERIC(2,1);
BEGIN
    SELECT AVG(Rating)::NUMERIC(2,1) INTO avg_res 
    FROM StoreLocations 
    WHERE City = city_name;
    RETURN COALESCE(avg_res, 0.0);
END;
$$ LANGUAGE plpgsql;

-- таблична функція пошук магазинів за містом та мінімальним рейтингом
CREATE OR REPLACE FUNCTION fn_GetStoresByFilter(p_city VARCHAR, p_min_rating NUMERIC)
RETURNS TABLE(StoreName VARCHAR, StoreRating NUMERIC) AS $$
BEGIN
    RETURN QUERY
    SELECT Name, Rating
    FROM StoreLocations
    WHERE City = p_city AND Rating >= p_min_rating;
END;
$$ LANGUAGE plpgsql;

-- процедура генерація нових магазинів
CREATE OR REPLACE PROCEDURE sp_GenerateStores(p_count INT DEFAULT 5)
AS $$
DECLARE
    i INT := 1;
BEGIN
    WHILE i <= p_count LOOP
        INSERT INTO StoreLocations (Name, Address, City, IsOpen, Rating)
        VALUES (
            'Store_' || i || '_' || floor(random()*100), 
            'Street ' || i, 
            (ARRAY['Kyiv', 'Kharkiv', 'Odesa'])[floor(random()*3)+1], 
            TRUE, 
            (RANDOM() * 5)::NUMERIC(2, 1)
        );
        i := i + 1;
    END LOOP;
END;
$$ LANGUAGE plpgsql;



-- генерація
CALL sp_GenerateStores(10);

-- скалярна функція
SELECT fn_GetAvgRatingByCity('Kyiv') AS "Average Rating in Kyiv";

-- таблична функція
SELECT * FROM fn_GetStoresByFilter('Kharkiv', 3.0);

-- View
SELECT * FROM View_TopActiveStores;

-- трігер
DELETE FROM StoreLocations WHERE Id = (SELECT MIN(Id) FROM StoreLocations);
SELECT * FROM StoreLocations_History;

-- UNION ALL
SELECT Name, City, 'ACTIVE' AS Status FROM StoreLocations
UNION ALL
SELECT Name, City, 'DELETED' AS Status FROM StoreLocations_History;