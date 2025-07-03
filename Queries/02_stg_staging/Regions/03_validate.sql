-- VALIDACIONES STG_Regions
-- Validaciones de calidad de datos para tabla STG_Regions

PRAGMA foreign_keys = ON;

-- ======================================
-- VALIDACIONES BÁSICAS
-- ======================================

-- Validar PK no nulos
INSERT INTO DQM_ControlProcesos 
(esquema, tabla, campo, proceso, descripcion, valor_esperado, valor_obtenado, resultado, timestamp)
SELECT 
    'STG', 'STG_Regions', 'regionID', 'VALIDACION_PK', 'Verificar PKs no nulos',
    0, COUNT(*), CASE WHEN COUNT(*) = 0 THEN 'SUCCESS' ELSE 'ERROR' END, datetime('now')
FROM STG_Regions 
WHERE regionID IS NULL;

-- Validar duplicados en PK
INSERT INTO DQM_ControlProcesos 
(esquema, tabla, campo, proceso, descripcion, valor_esperado, valor_obtenado, resultado, timestamp)
SELECT 
    'STG', 'STG_Regions', 'regionID', 'VALIDACION_PK', 'Verificar PKs únicos',
    (SELECT COUNT(*) FROM STG_Regions), COUNT(*), 
    CASE WHEN COUNT(*) = (SELECT COUNT(*) FROM STG_Regions) THEN 'SUCCESS' ELSE 'ERROR' END, datetime('now')
FROM (SELECT DISTINCT regionID FROM STG_Regions);

-- Validar campos obligatorios
INSERT INTO DQM_ControlProcesos 
(esquema, tabla, campo, proceso, descripcion, valor_esperado, valor_obtenado, resultado, timestamp)
SELECT 
    'STG', 'STG_Regions', 'regionDescription', 'VALIDACION_NULOS', 'Verificar regionDescription no nulos',
    0, COUNT(*), CASE WHEN COUNT(*) = 0 THEN 'SUCCESS' ELSE 'WARNING' END, datetime('now')
FROM STG_Regions 
WHERE regionDescription IS NULL OR TRIM(regionDescription) = '';

-- ======================================
-- VALIDACIONES DE COHERENCIA
-- ======================================

-- Verificar integridad con TMP
INSERT INTO DQM_ControlProcesos 
(esquema, tabla, campo, proceso, descripcion, valor_esperado, valor_obtenado, resultado, timestamp)
SELECT 
    'STG', 'STG_Regions', 'ALL', 'VALIDACION_INTEGRIDAD', 'Coherencia conteos STG vs TMP',
    (SELECT COUNT(*) FROM TMP_Regions), COUNT(*), 
    CASE WHEN COUNT(*) = (SELECT COUNT(*) FROM TMP_Regions) THEN 'SUCCESS' ELSE 'ERROR' END, datetime('now')
FROM STG_Regions;

-- ======================================
-- RESULTADO VALIDACIÓN
-- ======================================

SELECT 'VALIDACIÓN STG_Regions COMPLETADA' as resultado; 