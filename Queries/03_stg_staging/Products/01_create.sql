-- CREAR STG_Products
-- Versión limpia de TMP_Products con caracteres especiales normalizados

CREATE TABLE IF NOT EXISTS STG_Products (
    productID INTEGER PRIMARY KEY,
    productName TEXT,                       -- Nombre original (caracteres especiales son correctos)
    supplierID INTEGER,
    categoryID INTEGER,
    quantityPerUnit TEXT,                   -- Limpio (espacios extras eliminados)
    unitPrice REAL,
    unitsInStock INTEGER,
    unitsOnOrder INTEGER,
    reorderLevel INTEGER,
    discontinued INTEGER,
    -- Campos de auditoría staging
    stg_created_date DATE DEFAULT CURRENT_DATE,
    stg_data_quality_score REAL DEFAULT 1.0,
    -- FK constraints (opcionales en SQLite pero documentadas)
    FOREIGN KEY (supplierID) REFERENCES STG_Suppliers(supplierID),
    FOREIGN KEY (categoryID) REFERENCES STG_Categories(categoryID)
); 