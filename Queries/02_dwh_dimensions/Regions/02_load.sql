-- Limpieza previa: elimina los registros con regionID ya existentes para evitar duplicados

DELETE FROM DWH_Dim_Regions
WHERE regionID IN (SELECT regionID FROM TMP_Regions);

-- Inserción de datos desde TMP_Regions

INSERT INTO DWH_Dim_Regions
SELECT
  regionID,
  regionDescription
FROM TMP_Regions;
