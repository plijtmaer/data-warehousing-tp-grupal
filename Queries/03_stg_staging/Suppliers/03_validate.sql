-- VALIDACIONES STG_Suppliers
-- Validaciones de calidad de datos para tabla STG_Suppliers

PRAGMA foreign_keys = ON;

-- ======================================
-- VALIDACIONES BÁSICAS
-- ======================================

-- Validar PK no nulos
INSERT INTO DQM_ControlProcesos 
(esquema, tabla, campo, proceso, descripcion, valor_esperado, valor_obtenado, resultado, timestamp)
SELECT 
    'STG', 'STG_Suppliers', 'supplierID', 'VALIDACION_PK', 'Verificar PKs no nulos',
    0, COUNT(*), CASE WHEN COUNT(*) = 0 THEN 'SUCCESS' ELSE 'ERROR' END, datetime('now')
FROM STG_Suppliers 
WHERE supplierID IS NULL;

-- Validar duplicados en PK
INSERT INTO DQM_ControlProcesos 
(esquema, tabla, campo, proceso, descripcion, valor_esperado, valor_obtenado, resultado, timestamp)
SELECT 
    'STG', 'STG_Suppliers', 'supplierID', 'VALIDACION_PK', 'Verificar PKs únicos',
    (SELECT COUNT(*) FROM STG_Suppliers), COUNT(*), 
    CASE WHEN COUNT(*) = (SELECT COUNT(*) FROM STG_Suppliers) THEN 'SUCCESS' ELSE 'ERROR' END, datetime('now')
FROM (SELECT DISTINCT supplierID FROM STG_Suppliers);

-- Validar campos obligatorios
INSERT INTO DQM_ControlProcesos 
(esquema, tabla, campo, proceso, descripcion, valor_esperado, valor_obtenado, resultado, timestamp)
SELECT 
    'STG', 'STG_Suppliers', 'companyName', 'VALIDACION_NULOS', 'Verificar companyName no nulos',
    0, COUNT(*), CASE WHEN COUNT(*) = 0 THEN 'SUCCESS' ELSE 'WARNING' END, datetime('now')
FROM STG_Suppliers 
WHERE companyName IS NULL OR TRIM(companyName) = '';

-- ======================================
-- VALIDACIONES DE COHERENCIA
-- ======================================

-- Verificar integridad con TMP
INSERT INTO DQM_ControlProcesos 
(esquema, tabla, campo, proceso, descripcion, valor_esperado, valor_obtenado, resultado, timestamp)
SELECT 
    'STG', 'STG_Suppliers', 'ALL', 'VALIDACION_INTEGRIDAD', 'Coherencia conteos STG vs TMP',
    (SELECT COUNT(*) FROM TMP_Suppliers), COUNT(*), 
    CASE WHEN COUNT(*) = (SELECT COUNT(*) FROM TMP_Suppliers) THEN 'SUCCESS' ELSE 'ERROR' END, datetime('now')
FROM STG_Suppliers;

-- ======================================
-- RESULTADO VALIDACIÓN
-- ======================================

SELECT 'VALIDACIÓN STG_Suppliers COMPLETADA' as resultado; 