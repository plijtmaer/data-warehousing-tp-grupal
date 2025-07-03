-- VALIDACIONES STG_OrderDetails
-- Validaciones de calidad de datos para tabla STG_OrderDetails

PRAGMA foreign_keys = ON;

-- ======================================
-- VALIDACIONES BÁSICAS
-- ======================================

-- Validar PK compuesta no nula
INSERT INTO DQM_ControlProcesos 
(esquema, tabla, campo, proceso, descripcion, valor_esperado, valor_obtenido, resultado, timestamp)
SELECT 
    'STG', 'STG_OrderDetails', 'orderID', 'VALIDACION_PK', 'Verificar orderID no nulos',
    0, COUNT(*), CASE WHEN COUNT(*) = 0 THEN 'SUCCESS' ELSE 'ERROR' END, datetime('now')
FROM STG_OrderDetails 
WHERE orderID IS NULL;

INSERT INTO DQM_ControlProcesos 
(esquema, tabla, campo, proceso, descripcion, valor_esperado, valor_obtenido, resultado, timestamp)
SELECT 
    'STG', 'STG_OrderDetails', 'productID', 'VALIDACION_PK', 'Verificar productID no nulos',
    0, COUNT(*), CASE WHEN COUNT(*) = 0 THEN 'SUCCESS' ELSE 'ERROR' END, datetime('now')
FROM STG_OrderDetails 
WHERE productID IS NULL;

-- Validar duplicados en PK compuesta
INSERT INTO DQM_ControlProcesos 
(esquema, tabla, campo, proceso, descripcion, valor_esperado, valor_obtenido, resultado, timestamp)
SELECT 
    'STG', 'STG_OrderDetails', 'orderID|productID', 'VALIDACION_PK', 'Verificar PK compuesta única',
    (SELECT COUNT(*) FROM STG_OrderDetails), COUNT(*), 
    CASE WHEN COUNT(*) = (SELECT COUNT(*) FROM STG_OrderDetails) THEN 'SUCCESS' ELSE 'ERROR' END, datetime('now')
FROM (SELECT DISTINCT orderID, productID FROM STG_OrderDetails);

-- Validar valores numéricos
INSERT INTO DQM_ControlProcesos 
(esquema, tabla, campo, proceso, descripcion, valor_esperado, valor_obtenido, resultado, timestamp)
SELECT 
    'STG', 'STG_OrderDetails', 'quantity', 'VALIDACION_RANGOS', 'Verificar quantity > 0',
    0, COUNT(*), CASE WHEN COUNT(*) = 0 THEN 'SUCCESS' ELSE 'WARNING' END, datetime('now')
FROM STG_OrderDetails 
WHERE quantity <= 0;

-- ======================================
-- VALIDACIONES DE COHERENCIA
-- ======================================

-- Verificar integridad con TMP
INSERT INTO DQM_ControlProcesos 
(esquema, tabla, campo, proceso, descripcion, valor_esperado, valor_obtenido, resultado, timestamp)
SELECT 
    'STG', 'STG_OrderDetails', 'ALL', 'VALIDACION_INTEGRIDAD', 'Coherencia conteos STG vs TMP',
    (SELECT COUNT(*) FROM TMP_OrderDetails), COUNT(*), 
    CASE WHEN COUNT(*) = (SELECT COUNT(*) FROM TMP_OrderDetails) THEN 'SUCCESS' ELSE 'ERROR' END, datetime('now')
FROM STG_OrderDetails;

-- ======================================
-- RESULTADO VALIDACIÓN
-- ======================================

SELECT 'VALIDACIÓN STG_OrderDetails COMPLETADA' as resultado; 