-- CARGAR STG_Employees
-- Aplicando lógica del fix de jerarquía de TMP_Employees

PRAGMA foreign_keys = ON;

-- Registrar en DQM inicio del proceso
INSERT INTO DQM_ControlProcesos 
(esquema, tabla, campo, proceso, descripcion, valor_esperado, valor_obtenido, resultado, timestamp)
VALUES 
('STG', 'STG_Employees', 'ALL', 'CARGA_STG', 'Inicio carga STG_Employees con fix jerarquía', 'SUCCESS', 'INICIADO', 'INFO', datetime('now'));

-- Limpiar tabla staging
DELETE FROM STG_Employees;

-- Detectar empleados con jefe inexistente en TMP
INSERT INTO DQM_ControlProcesos 
(esquema, tabla, campo, proceso, descripcion, valor_esperado, valor_obtenido, resultado, timestamp)
SELECT 
    'TMP', 'TMP_Employees', 'reportsTo', 'VALIDACION_FK', 'Empleados con jefe inexistente',
    0, COUNT(*), CASE WHEN COUNT(*) = 0 THEN 'SUCCESS' ELSE 'WARNING' END, datetime('now')
FROM TMP_Employees e
WHERE reportsTo IS NOT NULL
  AND reportsTo NOT IN (SELECT employeeID FROM TMP_Employees);

-- PASO 1: Insertar VP (employeeID = 2) primero - corrigiendo reportsTo 'NULL' a NULL real
INSERT INTO STG_Employees (
    employeeID, lastName, firstName, title, titleOfCourtesy, birthDate, hireDate,
    address, city, region, postalCode, country, homePhone, extension, photo, notes,
    reportsTo, photoPath, stg_created_date, stg_data_quality_score
)
SELECT 
    employeeID, lastName, firstName, title, titleOfCourtesy, birthDate, hireDate,
    address, city, region, postalCode, country, homePhone, extension, photo, notes,
    CASE 
        WHEN TRIM(CAST(reportsTo AS TEXT)) = 'NULL' THEN NULL 
        ELSE reportsTo 
    END as reportsTo_fixed,
    photoPath, CURRENT_DATE, 1.0
FROM TMP_Employees 
WHERE employeeID = 2;

-- PASO 2: Insertar empleados que reportan directamente al VP (1,3,4,5,8)
INSERT INTO STG_Employees (
    employeeID, lastName, firstName, title, titleOfCourtesy, birthDate, hireDate,
    address, city, region, postalCode, country, homePhone, extension, photo, notes,
    reportsTo, photoPath, stg_created_date, stg_data_quality_score
)
SELECT 
    employeeID, lastName, firstName, title, titleOfCourtesy, birthDate, hireDate,
    address, city, region, postalCode, country, homePhone, extension, photo, notes,
    CASE 
        WHEN TRIM(CAST(reportsTo AS TEXT)) = 'NULL' THEN NULL 
        ELSE reportsTo 
    END as reportsTo_fixed,
    photoPath, CURRENT_DATE, 1.0
FROM TMP_Employees
WHERE employeeID IN (1, 3, 4, 5, 8);

-- PASO 3: Insertar resto de empleados (6,7,9)
INSERT INTO STG_Employees (
    employeeID, lastName, firstName, title, titleOfCourtesy, birthDate, hireDate,
    address, city, region, postalCode, country, homePhone, extension, photo, notes,
    reportsTo, photoPath, stg_created_date, stg_data_quality_score
)
SELECT 
    employeeID, lastName, firstName, title, titleOfCourtesy, birthDate, hireDate,
    address, city, region, postalCode, country, homePhone, extension, photo, notes,
    CASE 
        WHEN TRIM(CAST(reportsTo AS TEXT)) = 'NULL' THEN NULL 
        ELSE reportsTo 
    END as reportsTo_fixed,
    photoPath, CURRENT_DATE, 1.0
FROM TMP_Employees
WHERE employeeID IN (6, 7, 9);

-- Registrar resultado en DQM
INSERT INTO DQM_ControlProcesos 
(esquema, tabla, campo, proceso, descripcion, valor_esperado, valor_obtenido, resultado, timestamp)
VALUES 
('STG', 'STG_Employees', 'ALL', 'CARGA_STG', 'Carga completa STG_Employees con fix jerarquía', 
(SELECT COUNT(*) FROM TMP_Employees), (SELECT COUNT(*) FROM STG_Employees), 'SUCCESS', datetime('now'));

-- Verificar jerarquía en STG
INSERT INTO DQM_ControlProcesos 
(esquema, tabla, campo, proceso, descripcion, valor_esperado, valor_obtenido, resultado, timestamp)
SELECT 
    'STG', 'STG_Employees', 'reportsTo', 'VALIDACION_FK', 'Empleados con jefe inexistente post-fix',
    0, COUNT(*), CASE WHEN COUNT(*) = 0 THEN 'SUCCESS' ELSE 'ERROR' END, datetime('now')
FROM STG_Employees e
WHERE reportsTo IS NOT NULL
  AND reportsTo NOT IN (SELECT employeeID FROM STG_Employees);

-- Verificar resultados
SELECT 'STG_Employees - Total registros:' as info, COUNT(*) as cantidad FROM STG_Employees;
SELECT 'STG_Employees - VP (sin jefe):' as info, COUNT(*) as cantidad FROM STG_Employees WHERE reportsTo IS NULL;
SELECT 'STG_Employees - Con jefe:' as info, COUNT(*) as cantidad FROM STG_Employees WHERE reportsTo IS NOT NULL; 