-- CARGAR STG_Shippers
-- Copia directa de TMP_Shippers (sin transformaciones)

PRAGMA foreign_keys = ON;

-- Registrar en DQM inicio del proceso
INSERT INTO DQM_ControlProcesos 
(esquema, tabla, campo, proceso, descripcion, valor_esperado, valor_obtenido, resultado, timestamp)
VALUES 
('STG', 'STG_Shippers', 'ALL', 'CARGA_STG', 'Inicio carga STG_Shippers desde TMP_Shippers', 'SUCCESS', 'INICIADO', 'INFO', datetime('now'));

-- Limpiar tabla staging
DELETE FROM STG_Shippers;

-- Insertar datos desde TMP (copia directa)
INSERT INTO STG_Shippers (
    shipperID, companyName, phone,
    stg_created_date, stg_data_quality_score
)
SELECT 
    shipperID, companyName, phone,
    CURRENT_DATE, 1.0
FROM TMP_Shippers;

-- Registrar resultado en DQM
INSERT INTO DQM_ControlProcesos 
(esquema, tabla, campo, proceso, descripcion, valor_esperado, valor_obtenido, resultado, timestamp)
VALUES 
('STG', 'STG_Shippers', 'ALL', 'CARGA_STG', 'Carga completa STG_Shippers', 
(SELECT COUNT(*) FROM TMP_Shippers), (SELECT COUNT(*) FROM STG_Shippers), 'SUCCESS', datetime('now'));

-- Verificar resultados
SELECT 'STG_Shippers - Total registros:' as info, COUNT(*) as cantidad FROM STG_Shippers; 