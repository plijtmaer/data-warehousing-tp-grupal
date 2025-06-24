
-- Limpieza previa: elimina los registros con productID ya existentes para evitar duplicados

DELETE FROM DWH_Dim_Products
WHERE productID IN (SELECT productID FROM TMP_Products);


-- Inserción de datos desde TMP_Products

INSERT INTO DWH_Dim_Products
SELECT
	productID,
	productName,
	supplierID,
	categoryID,
	quantityPerUnit,
	unitPrice,
	unitsInStock,
	unitsOnOrder,
	reorderLevel,
	discontinued
FROM TMP_Products;