
-- Creación de tabla dimensional para productos

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