-- Control: verificar cantidad de productos a cargar
SELECT COUNT(*) as total_products FROM STG_Products;

-- Control: verificar precios negativos
SELECT COUNT(*) as precios_negativos FROM STG_Products WHERE unitPrice < 0;

-- Limpieza previa: elimina los registros con productID ya existentes para evitar duplicados
DELETE FROM DWH_Dim_Products
WHERE productID IN (SELECT productID FROM STG_Products);

-- Inserción de datos desde STG_Products (con limpieza de espacios)
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
FROM STG_Products;

-- Control posterior: verificar carga exitosa
SELECT COUNT(*) as products_cargados FROM DWH_Dim_Products;