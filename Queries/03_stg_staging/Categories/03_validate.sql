-- VALIDACIONES STG_Categories
-- Validaciones de calidad de datos para tabla STG_Categories

PRAGMA foreign_keys = ON;

-- ======================================
-- VALIDACIONES BÁSICAS
-- ======================================

-- Validar PK no nulos
INSERT INTO DQM_ControlProcesos 
(esquema, tabla, campo, proceso, descripcion, valor_esperado, valor_obtenado, resultado, timestamp)
SELECT 
    'STG', 'STG_Categories', 'categoryID', 'VALIDACION_PK', 'Verificar PKs no nulos',
    0, COUNT(*), CASE WHEN COUNT(*) = 0 THEN 'SUCCESS' ELSE 'ERROR' END, datetime('now')
FROM STG_Categories 
WHERE categoryID IS NULL;

-- Validar duplicados en PK
INSERT INTO DQM_ControlProcesos 
(esquema, tabla, campo, proceso, descripcion, valor_esperado, valor_obtenado, resultado, timestamp)
SELECT 
    'STG', 'STG_Categories', 'categoryID', 'VALIDACION_PK', 'Verificar PKs únicos',
    (SELECT COUNT(*) FROM STG_Categories), COUNT(*), 
    CASE WHEN COUNT(*) = (SELECT COUNT(*) FROM STG_Categories) THEN 'SUCCESS' ELSE 'ERROR' END, datetime('now')
FROM (SELECT DISTINCT categoryID FROM STG_Categories);

-- Validar campos obligatorios
INSERT INTO DQM_ControlProcesos 
(esquema, tabla, campo, proceso, descripcion, valor_esperado, valor_obtenado, resultado, timestamp)
SELECT 
    'STG', 'STG_Categories', 'categoryName', 'VALIDACION_NULOS', 'Verificar categoryName no nulos',
    0, COUNT(*), CASE WHEN COUNT(*) = 0 THEN 'SUCCESS' ELSE 'WARNING' END, datetime('now')
FROM STG_Categories 
WHERE categoryName IS NULL OR TRIM(categoryName) = '';

-- ======================================
-- VALIDACIONES DE COHERENCIA
-- ======================================

-- Verificar integridad con TMP
INSERT INTO DQM_ControlProcesos 
(esquema, tabla, campo, proceso, descripcion, valor_esperado, valor_obtenado, resultado, timestamp)
SELECT 
    'STG', 'STG_Categories', 'ALL', 'VALIDACION_INTEGRIDAD', 'Coherencia conteos STG vs TMP',
    (SELECT COUNT(*) FROM TMP_Categories), COUNT(*), 
    CASE WHEN COUNT(*) = (SELECT COUNT(*) FROM TMP_Categories) THEN 'SUCCESS' ELSE 'ERROR' END, datetime('now')
FROM STG_Categories;

-- ======================================
-- RESULTADO VALIDACIÓN
-- ======================================

SELECT 'VALIDACIÓN STG_Categories COMPLETADA' as resultado; 