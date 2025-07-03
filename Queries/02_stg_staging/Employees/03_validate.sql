-- VALIDACIONES STG_Employees
-- Validaciones de calidad de datos para tabla STG_Employees (con jerarquía)

PRAGMA foreign_keys = ON;

-- ======================================
-- VALIDACIONES BÁSICAS
-- ======================================

-- Validar PK no nulos
INSERT INTO DQM_ControlProcesos 
(esquema, tabla, campo, proceso, descripcion, valor_esperado, valor_obtenado, resultado, timestamp)
SELECT 
    'STG', 'STG_Employees', 'employeeID', 'VALIDACION_PK', 'Verificar PKs no nulos',
    0, COUNT(*), CASE WHEN COUNT(*) = 0 THEN 'SUCCESS' ELSE 'ERROR' END, datetime('now')
FROM STG_Employees 
WHERE employeeID IS NULL;

-- Validar duplicados en PK
INSERT INTO DQM_ControlProcesos 
(esquema, tabla, campo, proceso, descripcion, valor_esperado, valor_obtenado, resultado, timestamp)
SELECT 
    'STG', 'STG_Employees', 'employeeID', 'VALIDACION_PK', 'Verificar PKs únicos',
    (SELECT COUNT(*) FROM STG_Employees), COUNT(*), 
    CASE WHEN COUNT(*) = (SELECT COUNT(*) FROM STG_Employees) THEN 'SUCCESS' ELSE 'ERROR' END, datetime('now')
FROM (SELECT DISTINCT employeeID FROM STG_Employees);

-- Validar campos obligatorios
INSERT INTO DQM_ControlProcesos 
(esquema, tabla, campo, proceso, descripcion, valor_esperado, valor_obtenado, resultado, timestamp)
SELECT 
    'STG', 'STG_Employees', 'lastName', 'VALIDACION_NULOS', 'Verificar lastName no nulos',
    0, COUNT(*), CASE WHEN COUNT(*) = 0 THEN 'SUCCESS' ELSE 'WARNING' END, datetime('now')
FROM STG_Employees 
WHERE lastName IS NULL OR TRIM(lastName) = '';

INSERT INTO DQM_ControlProcesos 
(esquema, tabla, campo, proceso, descripcion, valor_esperado, valor_obtenado, resultado, timestamp)
SELECT 
    'STG', 'STG_Employees', 'firstName', 'VALIDACION_NULOS', 'Verificar firstName no nulos',
    0, COUNT(*), CASE WHEN COUNT(*) = 0 THEN 'SUCCESS' ELSE 'WARNING' END, datetime('now')
FROM STG_Employees 
WHERE firstName IS NULL OR TRIM(firstName) = '';

-- ======================================
-- VALIDACIONES JERÁRQUICAS ESPECÍFICAS
-- ======================================

-- Validar integridad referencial jerárquica
INSERT INTO DQM_ControlProcesos 
(esquema, tabla, campo, proceso, descripcion, valor_esperado, valor_obtenado, resultado, timestamp)
SELECT 
    'STG', 'STG_Employees', 'reportsTo', 'VALIDACION_FK', 'Verificar jerarquía intacta',
    0, COUNT(*), CASE WHEN COUNT(*) = 0 THEN 'SUCCESS' ELSE 'ERROR' END, datetime('now')
FROM STG_Employees e
WHERE reportsTo IS NOT NULL
  AND reportsTo NOT IN (SELECT employeeID FROM STG_Employees);

-- Validar VP único (sin jefe)
INSERT INTO DQM_ControlProcesos 
(esquema, tabla, campo, proceso, descripcion, valor_esperado, valor_obtenado, resultado, timestamp)
SELECT 
    'STG', 'STG_Employees', 'reportsTo', 'VALIDACION_JERARQUIA', 'Verificar VP único sin jefe',
    1, COUNT(*), CASE WHEN COUNT(*) = 1 THEN 'SUCCESS' ELSE 'WARNING' END, datetime('now')
FROM STG_Employees 
WHERE reportsTo IS NULL;

-- Validar que no hay ciclos jerárquicos (auto-referencia)
INSERT INTO DQM_ControlProcesos 
(esquema, tabla, campo, proceso, descripcion, valor_esperado, valor_obtenado, resultado, timestamp)
SELECT 
    'STG', 'STG_Employees', 'reportsTo', 'VALIDACION_JERARQUIA', 'Verificar sin auto-referencia',
    0, COUNT(*), CASE WHEN COUNT(*) = 0 THEN 'SUCCESS' ELSE 'ERROR' END, datetime('now')
FROM STG_Employees 
WHERE employeeID = reportsTo;

-- ======================================
-- VALIDACIONES DE COHERENCIA
-- ======================================

-- Verificar integridad con TMP
INSERT INTO DQM_ControlProcesos 
(esquema, tabla, campo, proceso, descripcion, valor_esperado, valor_obtenado, resultado, timestamp)
SELECT 
    'STG', 'STG_Employees', 'ALL', 'VALIDACION_INTEGRIDAD', 'Coherencia conteos STG vs TMP',
    (SELECT COUNT(*) FROM TMP_Employees), COUNT(*), 
    CASE WHEN COUNT(*) = (SELECT COUNT(*) FROM TMP_Employees) THEN 'SUCCESS' ELSE 'ERROR' END, datetime('now')
FROM STG_Employees;

-- Verificar que fix jerárquico funcionó correctamente
INSERT INTO DQM_ControlProcesos 
(esquema, tabla, campo, proceso, descripcion, valor_esperado, valor_obtenado, resultado, timestamp)
SELECT 
    'STG', 'STG_Employees', 'reportsTo', 'VALIDACION_FIX', 'Verificar VP ID=2 sin jefe',
    1, COUNT(*), CASE WHEN COUNT(*) = 1 THEN 'SUCCESS' ELSE 'ERROR' END, datetime('now')
FROM STG_Employees 
WHERE employeeID = 2 AND reportsTo IS NULL;

-- ======================================
-- RESULTADO VALIDACIÓN
-- ======================================

SELECT 'VALIDACIÓN STG_Employees COMPLETADA' as resultado; 