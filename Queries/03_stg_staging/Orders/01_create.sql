-- CREAR STG_Orders
-- Copia directa de TMP_Orders (datos ya limpios)

CREATE TABLE IF NOT EXISTS STG_Orders (
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
    -- Campos de auditoría staging
    stg_created_date DATE DEFAULT CURRENT_DATE,
    stg_data_quality_score REAL DEFAULT 1.0
); 