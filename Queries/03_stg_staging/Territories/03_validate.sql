-- VALIDACIONES STG_Territories
-- Validaciones de calidad de datos para tabla STG_Territories

PRAGMA foreign_keys = ON;

-- ======================================
-- VALIDACIONES BÁSICAS
-- ======================================

-- Validar PK no nulos
INSERT INTO DQM_ControlProcesos 
(esquema, tabla, campo, proceso, descripcion, valor_esperado, valor_obtenido, resultado, timestamp)
SELECT 
    'STG', 'STG_Territories', 'territoryID', 'VALIDACION_PK', 'Verificar PKs no nulos',
    0, COUNT(*), CASE WHEN COUNT(*) = 0 THEN 'SUCCESS' ELSE 'ERROR' END, datetime('now')
FROM STG_Territories 
WHERE territoryID IS NULL;

-- Validar duplicados en PK
INSERT INTO DQM_ControlProcesos 
(esquema, tabla, campo, proceso, descripcion, valor_esperado, valor_obtenido, resultado, timestamp)
SELECT 
    'STG', 'STG_Territories', 'territoryID', 'VALIDACION_PK', 'Verificar PKs únicos',
    (SELECT COUNT(*) FROM STG_Territories), COUNT(*), 
    CASE WHEN COUNT(*) = (SELECT COUNT(*) FROM STG_Territories) THEN 'SUCCESS' ELSE 'ERROR' END, datetime('now')
FROM (SELECT DISTINCT territoryID FROM STG_Territories);

-- Validar campos obligatorios
INSERT INTO DQM_ControlProcesos 
(esquema, tabla, campo, proceso, descripcion, valor_esperado, valor_obtenido, resultado, timestamp)
SELECT 
    'STG', 'STG_Territories', 'territoryDescription', 'VALIDACION_NULOS', 'Verificar territoryDescription no nulos',
    0, COUNT(*), CASE WHEN COUNT(*) = 0 THEN 'SUCCESS' ELSE 'WARNING' END, datetime('now')
FROM STG_Territories 
WHERE territoryDescription IS NULL OR TRIM(territoryDescription) = '';

-- ======================================
-- VALIDACIONES DE COHERENCIA
-- ======================================

-- Verificar integridad con TMP
INSERT INTO DQM_ControlProcesos 
(esquema, tabla, campo, proceso, descripcion, valor_esperado, valor_obtenido, resultado, timestamp)
SELECT 
    'STG', 'STG_Territories', 'ALL', 'VALIDACION_INTEGRIDAD', 'Coherencia conteos STG vs TMP',
    (SELECT COUNT(*) FROM TMP_Territories), COUNT(*), 
    CASE WHEN COUNT(*) = (SELECT COUNT(*) FROM TMP_Territories) THEN 'SUCCESS' ELSE 'ERROR' END, datetime('now')
FROM STG_Territories;

-- ======================================
-- RESULTADO VALIDACIÓN
-- ======================================

SELECT 'VALIDACIÓN STG_Territories COMPLETADA' as resultado; 