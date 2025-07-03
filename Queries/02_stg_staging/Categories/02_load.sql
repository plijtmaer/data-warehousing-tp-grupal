-- CARGAR STG_Categories
-- Copia directa de TMP_Categories (sin transformaciones)

PRAGMA foreign_keys = ON;

-- Registrar en DQM inicio del proceso
INSERT INTO DQM_ControlProcesos 
(esquema, tabla, campo, proceso, descripcion, valor_esperado, valor_obtenido, resultado, timestamp)
VALUES 
('STG', 'STG_Categories', 'ALL', 'CARGA_STG', 'Inicio carga STG_Categories desde TMP_Categories', 'SUCCESS', 'INICIADO', 'INFO', datetime('now'));

-- Limpiar tabla staging
DELETE FROM STG_Categories;

-- Insertar datos desde TMP (copia directa)
INSERT INTO STG_Categories (
    categoryID, categoryName, description, picture,
    stg_created_date, stg_data_quality_score
)
SELECT 
    categoryID, categoryName, description, picture,
    CURRENT_DATE, 1.0
FROM TMP_Categories;

-- Registrar resultado en DQM
INSERT INTO DQM_ControlProcesos 
(esquema, tabla, campo, proceso, descripcion, valor_esperado, valor_obtenido, resultado, timestamp)
VALUES 
('STG', 'STG_Categories', 'ALL', 'CARGA_STG', 'Carga completa STG_Categories', 
(SELECT COUNT(*) FROM TMP_Categories), (SELECT COUNT(*) FROM STG_Categories), 'SUCCESS', datetime('now'));

-- Verificar resultados
SELECT 'STG_Categories - Total registros:' as info, COUNT(*) as cantidad FROM STG_Categories; 