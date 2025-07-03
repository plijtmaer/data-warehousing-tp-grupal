-- CARGAR STG_EmployeeTerritories
-- Copia directa de TMP_EmployeeTerritories (sin transformaciones)

PRAGMA foreign_keys = ON;

-- Registrar en DQM inicio del proceso
INSERT INTO DQM_ControlProcesos 
(esquema, tabla, campo, proceso, descripcion, valor_esperado, valor_obtenido, resultado, timestamp)
VALUES 
('STG', 'STG_EmployeeTerritories', 'ALL', 'CARGA_STG', 'Inicio carga STG_EmployeeTerritories desde TMP_EmployeeTerritories', 'SUCCESS', 'INICIADO', 'INFO', datetime('now'));

-- Limpiar tabla staging
DELETE FROM STG_EmployeeTerritories;

-- Insertar datos desde TMP (copia directa)
INSERT INTO STG_EmployeeTerritories (
    employeeID, territoryID,
    stg_created_date, stg_data_quality_score
)
SELECT 
    employeeID, territoryID,
    CURRENT_DATE, 1.0
FROM TMP_EmployeeTerritories;

-- Registrar resultado en DQM
INSERT INTO DQM_ControlProcesos 
(esquema, tabla, campo, proceso, descripcion, valor_esperado, valor_obtenido, resultado, timestamp)
VALUES 
('STG', 'STG_EmployeeTerritories', 'ALL', 'CARGA_STG', 'Carga completa STG_EmployeeTerritories', 
(SELECT COUNT(*) FROM TMP_EmployeeTerritories), (SELECT COUNT(*) FROM STG_EmployeeTerritories), 'SUCCESS', datetime('now'));

-- Verificar resultados
SELECT 'STG_EmployeeTerritories - Total registros:' as info, COUNT(*) as cantidad FROM STG_EmployeeTerritories; 