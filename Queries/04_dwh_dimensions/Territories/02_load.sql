-- Control previo: verificar que hay datos para cargar
SELECT COUNT(*) as total_territories FROM STG_Territories;

-- Control: verificar que no hay territoryID nulos
SELECT COUNT(*) as territories_sin_id FROM STG_Territories WHERE territoryID IS NULL;

-- Limpieza previa: elimina los registros con territoryID ya existentes para evitar duplicados
DELETE FROM DWH_Dim_Territories
WHERE territoryID IN (SELECT territoryID FROM STG_Territories);

-- Inserción desde STG_Territories
INSERT INTO DWH_Dim_Territories
SELECT
	territoryID,
	territoryDescription,
	regionID
FROM STG_Territories;

-- Control posterior: verificar que se cargaron los datos
SELECT COUNT(*) as territories_cargados FROM DWH_Dim_Territories;
