-- VALIDACIONES STG_EmployeeTerritories
-- Validaciones de calidad de datos para tabla STG_EmployeeTerritories

PRAGMA foreign_keys = ON;

-- ======================================
-- VALIDACIONES BÁSICAS
-- ======================================

-- Validar PK compuesta no nula
INSERT INTO DQM_ControlProcesos 
(esquema, tabla, campo, proceso, descripcion, valor_esperado, valor_obtenado, resultado, timestamp)
SELECT 
    'STG', 'STG_EmployeeTerritories', 'employeeID', 'VALIDACION_PK', 'Verificar employeeID no nulos',
    0, COUNT(*), CASE WHEN COUNT(*) = 0 THEN 'SUCCESS' ELSE 'ERROR' END, datetime('now')
FROM STG_EmployeeTerritories 
WHERE employeeID IS NULL;

INSERT INTO DQM_ControlProcesos 
(esquema, tabla, campo, proceso, descripcion, valor_esperado, valor_obtenado, resultado, timestamp)
SELECT 
    'STG', 'STG_EmployeeTerritories', 'territoryID', 'VALIDACION_PK', 'Verificar territoryID no nulos',
    0, COUNT(*), CASE WHEN COUNT(*) = 0 THEN 'SUCCESS' ELSE 'ERROR' END, datetime('now')
FROM STG_EmployeeTerritories 
WHERE territoryID IS NULL;

-- Validar duplicados en PK compuesta
INSERT INTO DQM_ControlProcesos 
(esquema, tabla, campo, proceso, descripcion, valor_esperado, valor_obtenado, resultado, timestamp)
SELECT 
    'STG', 'STG_EmployeeTerritories', 'employeeID|territoryID', 'VALIDACION_PK', 'Verificar PK compuesta única',
    (SELECT COUNT(*) FROM STG_EmployeeTerritories), COUNT(*), 
    CASE WHEN COUNT(*) = (SELECT COUNT(*) FROM STG_EmployeeTerritories) THEN 'SUCCESS' ELSE 'ERROR' END, datetime('now')
FROM (SELECT DISTINCT employeeID, territoryID FROM STG_EmployeeTerritories);

-- ======================================
-- VALIDACIONES DE COHERENCIA
-- ======================================

-- Verificar integridad con TMP
INSERT INTO DQM_ControlProcesos 
(esquema, tabla, campo, proceso, descripcion, valor_esperado, valor_obtenado, resultado, timestamp)
SELECT 
    'STG', 'STG_EmployeeTerritories', 'ALL', 'VALIDACION_INTEGRIDAD', 'Coherencia conteos STG vs TMP',
    (SELECT COUNT(*) FROM TMP_EmployeeTerritories), COUNT(*), 
    CASE WHEN COUNT(*) = (SELECT COUNT(*) FROM TMP_EmployeeTerritories) THEN 'SUCCESS' ELSE 'ERROR' END, datetime('now')
FROM STG_EmployeeTerritories;

-- ======================================
-- RESULTADO VALIDACIÓN
-- ======================================

SELECT 'VALIDACIÓN STG_EmployeeTerritories COMPLETADA' as resultado; 