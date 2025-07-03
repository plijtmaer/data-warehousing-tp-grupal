-- CREAR STG_EmployeeTerritories
-- Copia directa de TMP_EmployeeTerritories (datos ya limpios)

CREATE TABLE IF NOT EXISTS STG_EmployeeTerritories (
    employeeID INTEGER,
    territoryID TEXT,
    -- Campos de auditoría staging
    stg_created_date DATE DEFAULT CURRENT_DATE,
    stg_data_quality_score REAL DEFAULT 1.0,
    PRIMARY KEY (employeeID, territoryID)
); 