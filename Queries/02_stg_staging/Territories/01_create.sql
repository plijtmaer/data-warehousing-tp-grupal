-- CREAR STG_Territories
-- Copia directa de TMP_Territories (datos ya limpios)

CREATE TABLE IF NOT EXISTS STG_Territories (
    territoryID TEXT PRIMARY KEY,
    territoryDescription TEXT,
    regionID INTEGER,
    -- Campos de auditoría staging
    stg_created_date DATE DEFAULT CURRENT_DATE,
    stg_data_quality_score REAL DEFAULT 1.0
); 