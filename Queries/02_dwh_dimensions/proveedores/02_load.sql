-- Limpieza previa: elimina los registros con supplierID ya existentes para evitar duplicados

DELETE FROM DWH_DIM_Suppliers
WHERE supplierID IN (SELECT supplierID FROM TMP_Suppliers);


-- Inserción de datos desde TMP_Suppliers

INSERT INTO DWH_DIM_Suppliers
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
FROM TMP_Suppliers