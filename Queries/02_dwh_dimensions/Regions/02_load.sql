-- Control previo: verificar que hay datos para cargar
SELECT COUNT(*) as total_regions FROM STG_Regions;

-- Control: verificar que no hay regionID nulos
SELECT COUNT(*) as regions_sin_id FROM STG_Regions WHERE regionID IS NULL;

-- Limpieza previa: elimina los registros con regionID ya existentes para evitar duplicados
DELETE FROM DWH_Dim_Regions
WHERE regionID IN (SELECT regionID FROM STG_Regions);

-- Inserción desde STG_Regions
INSERT INTO DWH_Dim_Regions
SELECT
	regionID,
	regionDescription
FROM STG_Regions;

-- Control posterior: verificar que se cargaron los datos
SELECT COUNT(*) as regions_cargadas FROM DWH_Dim_Regions;
