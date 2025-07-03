-- CARGAR STG_Territories
-- Copia directa de TMP_Territories (sin transformaciones)

PRAGMA foreign_keys = ON;

-- Registrar en DQM inicio del proceso
INSERT INTO DQM_ControlProcesos 
(esquema, tabla, campo, proceso, descripcion, valor_esperado, valor_obtenido, resultado, timestamp)
VALUES 
('STG', 'STG_Territories', 'ALL', 'CARGA_STG', 'Inicio carga STG_Territories desde TMP_Territories', 'SUCCESS', 'INICIADO', 'INFO', datetime('now'));

-- Limpiar tabla staging
DELETE FROM STG_Territories;

-- Insertar datos desde TMP (copia directa)
INSERT INTO STG_Territories (
    territoryID, territoryDescription, regionID,
    stg_created_date, stg_data_quality_score
)
SELECT 
    territoryID, territoryDescription, regionID,
    CURRENT_DATE, 1.0
FROM TMP_Territories;

-- Registrar resultado en DQM
INSERT INTO DQM_ControlProcesos 
(esquema, tabla, campo, proceso, descripcion, valor_esperado, valor_obtenido, resultado, timestamp)
VALUES 
('STG', 'STG_Territories', 'ALL', 'CARGA_STG', 'Carga completa STG_Territories', 
(SELECT COUNT(*) FROM TMP_Territories), (SELECT COUNT(*) FROM STG_Territories), 'SUCCESS', datetime('now'));

-- Verificar resultados
SELECT 'STG_Territories - Total registros:' as info, COUNT(*) as cantidad FROM STG_Territories; 