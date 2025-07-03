-- CARGAR STG_Orders
-- Copia directa de TMP_Orders (sin transformaciones)

PRAGMA foreign_keys = ON;

-- Registrar en DQM inicio del proceso
INSERT INTO DQM_ControlProcesos 
(esquema, tabla, campo, proceso, descripcion, valor_esperado, valor_obtenido, resultado, timestamp)
VALUES 
('STG', 'STG_Orders', 'ALL', 'CARGA_STG', 'Inicio carga STG_Orders desde TMP_Orders', 'SUCCESS', 'INICIADO', 'INFO', datetime('now'));

-- Limpiar tabla staging
DELETE FROM STG_Orders;

-- Insertar datos desde TMP (copia directa)
INSERT INTO STG_Orders (
    orderID, customerID, employeeID, orderDate, requiredDate, shippedDate, shipVia, 
    freight, shipName, shipAddress, shipCity, shipRegion, shipPostalCode, shipCountry,
    stg_created_date, stg_data_quality_score
)
SELECT 
    orderID, customerID, employeeID, orderDate, requiredDate, shippedDate, shipVia,
    freight, shipName, shipAddress, shipCity, shipRegion, shipPostalCode, shipCountry,
    CURRENT_DATE, 1.0
FROM TMP_Orders;

-- Registrar resultado en DQM
INSERT INTO DQM_ControlProcesos 
(esquema, tabla, campo, proceso, descripcion, valor_esperado, valor_obtenido, resultado, timestamp)
VALUES 
('STG', 'STG_Orders', 'ALL', 'CARGA_STG', 'Carga completa STG_Orders', 
(SELECT COUNT(*) FROM TMP_Orders), (SELECT COUNT(*) FROM STG_Orders), 'SUCCESS', datetime('now'));

-- Verificar resultados
SELECT 'STG_Orders - Total registros:' as info, COUNT(*) as cantidad FROM STG_Orders; 