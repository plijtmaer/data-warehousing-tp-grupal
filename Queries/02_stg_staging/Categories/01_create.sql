-- CREAR STG_Categories
-- Copia directa de TMP_Categories (datos ya limpios)

CREATE TABLE IF NOT EXISTS STG_Categories (
    categoryID INTEGER PRIMARY KEY,
    categoryName TEXT,
    description TEXT,
    picture TEXT,
    -- Campos de auditoría staging
    stg_created_date DATE DEFAULT CURRENT_DATE,
    stg_data_quality_score REAL DEFAULT 1.0
); 