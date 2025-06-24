-- Limpieza previa: elimina los registros con categoryID ya existentes para evitar duplicados

DELETE FROM DWH_Dim_Categories
WHERE categoryID IN (SELECT categoryID FROM TMP_Categories);


-- Inserción de datos desde TMP_Categories
INSERT INTO DWH_Dim_Categories
SELECT
  categoryID,
  categoryName,
  description
FROM TMP_Categories;
