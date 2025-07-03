-- AREA TEMPORAL PARA INGESTA2
-- Punto 9a: Persistir novedades en tablas temporales separadas

-- Tabla temporal para customers novedades
CREATE TABLE IF NOT EXISTS TMP_Customers_ING2 (
    customerID TEXT PRIMARY KEY,
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
    tipo_operacion TEXT DEFAULT 'UPDATE' -- 'INSERT', 'UPDATE', 'DELETE'
);

-- Tabla temporal para orders novedades
CREATE TABLE IF NOT EXISTS TMP_Orders_ING2 (
    orderID INTEGER PRIMARY KEY,
    customerID TEXT,
    employeeID INTEGER,
    orderDate TEXT,
    requiredDate TEXT,
    shippedDate TEXT,
    shipVia INTEGER,
    freight REAL,
    shipName TEXT,
    shipAddress TEXT,
    shipCity TEXT,
    shipRegion TEXT,
    shipPostalCode TEXT,
    shipCountry TEXT,
    tipo_operacion TEXT DEFAULT 'INSERT'
);

-- Tabla temporal para order_details novedades
CREATE TABLE IF NOT EXISTS TMP_OrderDetails_ING2 (
    orderID INTEGER,
    productID INTEGER,
    unitPrice REAL,
    quantity INTEGER,
    discount REAL,
    tipo_operacion TEXT DEFAULT 'INSERT',
    PRIMARY KEY (orderID, productID)
);

-- Controles post-carga Ingesta2
-- Ejecutar después de importar los CSV de novedades

SELECT 'TMP_Customers_ING2' as tabla, COUNT(*) as registros FROM TMP_Customers_ING2
UNION ALL
SELECT 'TMP_Orders_ING2' as tabla, COUNT(*) as registros FROM TMP_Orders_ING2
UNION ALL  
SELECT 'TMP_OrderDetails_ING2' as tabla, COUNT(*) as registros FROM TMP_OrderDetails_ING2; 