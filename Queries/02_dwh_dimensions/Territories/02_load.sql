-- Limpieza previa: elimina los registros con territoryID ya existentes para evitar duplicados

DELETE FROM DWH_Dim_Territories
WHERE territoryID IN (SELECT territoryID FROM TMP_Territories);

-- Inserción de datos desde TMP_Territories

INSERT INTO DWH_Dim_Territories
SELECT
  territoryID,
  territoryDescription,
  regionID
FROM TMP_Territories;
