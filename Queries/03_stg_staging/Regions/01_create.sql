-- CREAR STG_Regions
-- Copia directa de TMP_Regions (datos ya limpios)

CREATE TABLE IF NOT EXISTS STG_Regions (
    regionID INTEGER PRIMARY KEY,
    regionDescription TEXT,
    -- Campos de auditoría staging
    stg_created_date DATE DEFAULT CURRENT_DATE,
    stg_data_quality_score REAL DEFAULT 1.0
); 