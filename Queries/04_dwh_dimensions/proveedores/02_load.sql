-- Control previo: verificar que hay datos para cargar
SELECT COUNT(*) as total_suppliers FROM STG_Suppliers;

-- Control: verificar que no hay supplierID nulos
SELECT COUNT(*) as suppliers_sin_id FROM STG_Suppliers WHERE supplierID IS NULL;

-- Limpieza previa: elimina los registros con supplierID ya existentes para evitar duplicados
DELETE FROM DWH_Dim_Proveedores
WHERE supplierID IN (SELECT supplierID FROM STG_Suppliers);

-- Inserción desde STG_Suppliers
INSERT INTO DWH_Dim_Proveedores
SELECT
	supplierID,
	companyName,
	contactName,
	contactTitle,
	address,
	city,
	region,
	postalCode,
	country,
	phone,
	fax,
	homePage
FROM STG_Suppliers;

-- Control posterior: verificar que se cargaron los datos
SELECT COUNT(*) as suppliers_cargados FROM DWH_Dim_Proveedores;