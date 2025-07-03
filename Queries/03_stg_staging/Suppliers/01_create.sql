-- CREAR STG_Suppliers
-- Copia directa de TMP_Suppliers (datos ya limpios)

CREATE TABLE IF NOT EXISTS STG_Suppliers (
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
    homePage TEXT,
    -- Campos de auditoría staging
    stg_created_date DATE DEFAULT CURRENT_DATE,
    stg_data_quality_score REAL DEFAULT 1.0
); 