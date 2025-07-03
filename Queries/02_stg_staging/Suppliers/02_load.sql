-- CARGAR STG_Suppliers
-- Copia directa de TMP_Suppliers (sin transformaciones)

PRAGMA foreign_keys = ON;

-- Registrar en DQM inicio del proceso
INSERT INTO DQM_ControlProcesos 
(esquema, tabla, campo, proceso, descripcion, valor_esperado, valor_obtenido, resultado, timestamp)
VALUES 
('STG', 'STG_Suppliers', 'ALL', 'CARGA_STG', 'Inicio carga STG_Suppliers desde TMP_Suppliers', 'SUCCESS', 'INICIADO', 'INFO', datetime('now'));

-- Limpiar tabla staging
DELETE FROM STG_Suppliers;

-- Insertar datos desde TMP (copia directa)
INSERT INTO STG_Suppliers (
    supplierID, companyName, contactName, contactTitle, address, city, region, 
    postalCode, country, phone, fax, homePage, stg_created_date, stg_data_quality_score
)
SELECT 
    supplierID, companyName, contactName, contactTitle, address, city, region,
    postalCode, country, phone, fax, homePage, CURRENT_DATE, 1.0
FROM TMP_Suppliers;

-- Registrar resultado en DQM
INSERT INTO DQM_ControlProcesos 
(esquema, tabla, campo, proceso, descripcion, valor_esperado, valor_obtenido, resultado, timestamp)
VALUES 
('STG', 'STG_Suppliers', 'ALL', 'CARGA_STG', 'Carga completa STG_Suppliers', 
(SELECT COUNT(*) FROM TMP_Suppliers), (SELECT COUNT(*) FROM STG_Suppliers), 'SUCCESS', datetime('now'));

-- Verificar resultados
SELECT 'STG_Suppliers - Total registros:' as info, COUNT(*) as cantidad FROM STG_Suppliers; 