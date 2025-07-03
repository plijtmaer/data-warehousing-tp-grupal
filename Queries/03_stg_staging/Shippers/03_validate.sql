-- VALIDACIONES STG_Shippers
-- Validaciones de calidad de datos para tabla STG_Shippers

PRAGMA foreign_keys = ON;

-- ======================================
-- VALIDACIONES BÁSICAS
-- ======================================

-- Validar PK no nulos
INSERT INTO DQM_ControlProcesos 
(esquema, tabla, campo, proceso, descripcion, valor_esperado, valor_obtenado, resultado, timestamp)
SELECT 
    'STG', 'STG_Shippers', 'shipperID', 'VALIDACION_PK', 'Verificar PKs no nulos',
    0, COUNT(*), CASE WHEN COUNT(*) = 0 THEN 'SUCCESS' ELSE 'ERROR' END, datetime('now')
FROM STG_Shippers 
WHERE shipperID IS NULL;

-- Validar duplicados en PK
INSERT INTO DQM_ControlProcesos 
(esquema, tabla, campo, proceso, descripcion, valor_esperado, valor_obtenado, resultado, timestamp)
SELECT 
    'STG', 'STG_Shippers', 'shipperID', 'VALIDACION_PK', 'Verificar PKs únicos',
    (SELECT COUNT(*) FROM STG_Shippers), COUNT(*), 
    CASE WHEN COUNT(*) = (SELECT COUNT(*) FROM STG_Shippers) THEN 'SUCCESS' ELSE 'ERROR' END, datetime('now')
FROM (SELECT DISTINCT shipperID FROM STG_Shippers);

-- Validar campos obligatorios
INSERT INTO DQM_ControlProcesos 
(esquema, tabla, campo, proceso, descripcion, valor_esperado, valor_obtenado, resultado, timestamp)
SELECT 
    'STG', 'STG_Shippers', 'companyName', 'VALIDACION_NULOS', 'Verificar companyName no nulos',
    0, COUNT(*), CASE WHEN COUNT(*) = 0 THEN 'SUCCESS' ELSE 'WARNING' END, datetime('now')
FROM STG_Shippers 
WHERE companyName IS NULL OR TRIM(companyName) = '';

-- ======================================
-- VALIDACIONES DE COHERENCIA
-- ======================================

-- Verificar integridad con TMP
INSERT INTO DQM_ControlProcesos 
(esquema, tabla, campo, proceso, descripcion, valor_esperado, valor_obtenado, resultado, timestamp)
SELECT 
    'STG', 'STG_Shippers', 'ALL', 'VALIDACION_INTEGRIDAD', 'Coherencia conteos STG vs TMP',
    (SELECT COUNT(*) FROM TMP_Shippers), COUNT(*), 
    CASE WHEN COUNT(*) = (SELECT COUNT(*) FROM TMP_Shippers) THEN 'SUCCESS' ELSE 'ERROR' END, datetime('now')
FROM STG_Shippers;

-- ======================================
-- RESULTADO VALIDACIÓN
-- ======================================

SELECT 'VALIDACIÓN STG_Shippers COMPLETADA' as resultado; 