-- Control: verificar cantidad de productos a cargar
SELECT COUNT(*) as total_products FROM TMP_Products;

-- Control: verificar precios negativos
SELECT COUNT(*) as precios_negativos FROM TMP_Products WHERE unitPrice < 0;

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

-- Control posterior: verificar carga exitosa
SELECT COUNT(*) as products_cargados FROM DWH_Dim_Products;