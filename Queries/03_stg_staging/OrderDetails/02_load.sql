-- CARGAR STG_OrderDetails
-- Copia directa de TMP_OrderDetails (sin transformaciones)

PRAGMA foreign_keys = ON;

-- Registrar en DQM inicio del proceso
INSERT INTO DQM_ControlProcesos 
(esquema, tabla, campo, proceso, descripcion, valor_esperado, valor_obtenido, resultado, timestamp)
VALUES 
('STG', 'STG_OrderDetails', 'ALL', 'CARGA_STG', 'Inicio carga STG_OrderDetails desde TMP_OrderDetails', 'SUCCESS', 'INICIADO', 'INFO', datetime('now'));

-- Limpiar tabla staging
DELETE FROM STG_OrderDetails;

-- Insertar datos desde TMP (copia directa)
INSERT INTO STG_OrderDetails (
    orderID, productID, unitPrice, quantity, discount,
    stg_created_date, stg_data_quality_score
)
SELECT 
    orderID, productID, unitPrice, quantity, discount,
    CURRENT_DATE, 1.0
FROM TMP_OrderDetails;

-- Registrar resultado en DQM
INSERT INTO DQM_ControlProcesos 
(esquema, tabla, campo, proceso, descripcion, valor_esperado, valor_obtenido, resultado, timestamp)
VALUES 
('STG', 'STG_OrderDetails', 'ALL', 'CARGA_STG', 'Carga completa STG_OrderDetails', 
(SELECT COUNT(*) FROM TMP_OrderDetails), (SELECT COUNT(*) FROM STG_OrderDetails), 'SUCCESS', datetime('now'));

-- Verificar resultados
SELECT 'STG_OrderDetails - Total registros:' as info, COUNT(*) as cantidad FROM STG_OrderDetails; 