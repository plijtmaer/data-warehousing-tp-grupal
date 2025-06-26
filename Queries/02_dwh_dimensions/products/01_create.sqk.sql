
-- Creación de tabla dimensional para productos
-- Se incluyen todos los campos para analisis de ventas, precios y stock
-- Todos los campos son utiles para reportes de productos

CREATE TABLE IF NOT EXISTS DWH_Dim_Products (
	productID INTEGER PRIMARY KEY,
	productName TEXT,
	supplierID INTEGER,
	categoryID INTEGER,
	quantityPerUnit TEXT,
	unitPrice REAL,
	unitsInStock INTEGER,
	unitsOnOrder INTEGER,
	reorderLevel INTEGER,
	discontinued INTEGER
);