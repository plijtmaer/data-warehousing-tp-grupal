-- CREAR STG_Shippers
-- Copia directa de TMP_Shippers (datos ya limpios)

CREATE TABLE IF NOT EXISTS STG_Shippers (
    shipperID INTEGER PRIMARY KEY,
    companyName TEXT,
    phone TEXT,
    -- Campos de auditoría staging
    stg_created_date DATE DEFAULT CURRENT_DATE,
    stg_data_quality_score REAL DEFAULT 1.0
); 