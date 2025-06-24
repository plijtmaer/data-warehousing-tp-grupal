-- Limpieza previa: elimina los registros con shipperID ya existentes para evitar duplicados

DELETE FROM DWH_Dim_Shippers
WHERE shipperID IN (SELECT shipperID FROM TMP_Shippers);


-- Inserción de datos desde TMP_Shippers
INSERT INTO DWH_Dim_Shippers
SELECT
  shipperID,
  companyName,
  phone
FROM TMP_Shippers;
