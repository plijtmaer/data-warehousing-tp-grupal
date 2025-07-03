-- Creación de tabla dimensional para proveedores
CREATE TABLE IF NOT EXISTS DWH_Dim_Suppliers (
	supplierID INTEGER PRIMARY KEY,
	companyName TEXT,
	contactName TEXT,
	contactTitle TEXT,
	address TEXT,
	city TEXT,
	region TEXT,
	postalCode TEXT,
	country TEXT,
	phone TEXT,
	fax TEXT,
	homepage TEXT
);