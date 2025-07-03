-- Control previo: verificar que hay datos para cargar
SELECT COUNT(*) as total_shippers FROM STG_Shippers;

-- Control: verificar que no hay shipperID nulos
SELECT COUNT(*) as shippers_sin_id FROM STG_Shippers WHERE shipperID IS NULL;

-- Limpieza previa: elimina los registros con shipperID ya existentes para evitar duplicados
DELETE FROM DWH_Dim_Shippers
WHERE shipperID IN (SELECT shipperID FROM STG_Shippers);

-- Inserción desde STG_Shippers
INSERT INTO DWH_Dim_Shippers
SELECT
	shipperID,
	companyName,
	phone
FROM STG_Shippers;

-- Control posterior: verificar que se cargaron los datos
SELECT COUNT(*) as shippers_cargados FROM DWH_Dim_Shippers;
