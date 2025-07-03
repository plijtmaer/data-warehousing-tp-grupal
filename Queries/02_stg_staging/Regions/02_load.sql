-- CARGAR STG_Regions
-- Copia directa de TMP_Regions (sin transformaciones)

PRAGMA foreign_keys = ON;

-- Registrar en DQM inicio del proceso
INSERT INTO DQM_ControlProcesos 
(esquema, tabla, campo, proceso, descripcion, valor_esperado, valor_obtenido, resultado, timestamp)
VALUES 
('STG', 'STG_Regions', 'ALL', 'CARGA_STG', 'Inicio carga STG_Regions desde TMP_Regions', 'SUCCESS', 'INICIADO', 'INFO', datetime('now'));

-- Limpiar tabla staging
DELETE FROM STG_Regions;

-- Insertar datos desde TMP (copia directa)
INSERT INTO STG_Regions (
    regionID, regionDescription,
    stg_created_date, stg_data_quality_score
)
SELECT 
    regionID, regionDescription,
    CURRENT_DATE, 1.0
FROM TMP_Regions;

-- Registrar resultado en DQM
INSERT INTO DQM_ControlProcesos 
(esquema, tabla, campo, proceso, descripcion, valor_esperado, valor_obtenido, resultado, timestamp)
VALUES 
('STG', 'STG_Regions', 'ALL', 'CARGA_STG', 'Carga completa STG_Regions', 
(SELECT COUNT(*) FROM TMP_Regions), (SELECT COUNT(*) FROM STG_Regions), 'SUCCESS', datetime('now'));

-- Verificar resultados
SELECT 'STG_Regions - Total registros:' as info, COUNT(*) as cantidad FROM STG_Regions; 