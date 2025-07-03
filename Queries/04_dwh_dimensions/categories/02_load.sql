-- Control previo
SELECT COUNT(*) as total_categories FROM STG_Categories;

-- Limpieza previa
DELETE FROM DWH_Dim_Categories;

-- Inserción desde STG_Categories
INSERT INTO DWH_Dim_Categories
SELECT
	categoryID,
	categoryName,
	description,
	picture
FROM STG_Categories;
