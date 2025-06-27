-- MERGE ORDERS Y ORDER_DETAILS - Punto 9c
-- Principalmente altas (nuevos pedidos) con orden de prevalencia

-- Registrar proceso de actualización Orders
INSERT INTO DQM_Procesos (
  nombre_proceso, tipo_proceso, tabla_origen, tabla_destino,
  estado, observaciones
) VALUES (
  'Merge Orders Ingesta2', 'merge', 'TMP_Orders_ING2', 'DWH_Fact_Orders',
  'en_proceso', 'Aplicando nuevos pedidos'
);

-- 1. INSERTAR NUEVAS ORDERS EN FACT TABLE
-- Solo insertar si no existen (evitar duplicados)
INSERT INTO DWH_Fact_Orders (
  orderID, customerID, employeeID, shipperID, 
  orderDate, requiredDate, shippedDate, freight
)
SELECT 
  o2.orderID, o2.customerID, o2.employeeID, o2.shipVia,
  o2.orderDate, o2.requiredDate, o2.shippedDate, o2.freight
FROM TMP_Orders_ING2 o2
WHERE o2.orderID NOT IN (SELECT orderID FROM DWH_Fact_Orders);

-- Registrar proceso de actualización OrderDetails
INSERT INTO DQM_Procesos (
  nombre_proceso, tipo_proceso, tabla_origen, tabla_destino,
  estado, observaciones
) VALUES (
  'Merge OrderDetails Ingesta2', 'merge', 'TMP_OrderDetails_ING2', 'DWH_Fact_OrderDetails',
  'en_proceso', 'Aplicando detalles de nuevos pedidos'
);

-- 2. INSERTAR ORDER_DETAILS CON VALIDACION
-- Solo insertar si la order existe y el detail no existe
INSERT INTO DWH_Fact_OrderDetails (
  orderID, productID, unitPrice, quantity, discount
)
SELECT 
  od2.orderID, od2.productID, od2.unitPrice, od2.quantity, od2.discount
FROM TMP_OrderDetails_ING2 od2
WHERE od2.orderID IN (SELECT orderID FROM DWH_Fact_Orders)  -- Order debe existir
  AND NOT EXISTS (  -- Detail no debe existir
    SELECT 1 FROM DWH_Fact_OrderDetails existing
    WHERE existing.orderID = od2.orderID 
    AND existing.productID = od2.productID
  );

-- 3. VERIFICAR INTEGRIDAD DESPUES DEL MERGE
INSERT INTO DQM_Indicadores (
  proceso_id, tipo_indicador, tabla_nombre, campo_nombre,
  valor_indicador, umbral_minimo, resultado, descripcion
)
SELECT 
  (SELECT MAX(proceso_id) FROM DQM_Procesos WHERE nombre_proceso = 'Merge OrderDetails Ingesta2'),
  'integridad',
  'DWH_Fact_OrderDetails',
  'orderID',
  ROUND(
    (SELECT COUNT(*) FROM DWH_Fact_OrderDetails od
     WHERE od.orderID IN (SELECT orderID FROM DWH_Fact_Orders)) * 100.0 / 
    (SELECT COUNT(*) FROM DWH_Fact_OrderDetails)
  ),
  100.0,
  CASE 
    WHEN (SELECT COUNT(*) FROM DWH_Fact_OrderDetails od
          WHERE od.orderID NOT IN (SELECT orderID FROM DWH_Fact_Orders)) = 0 
    THEN 'aprobado'
    ELSE 'rechazado'
  END,
  'Integridad referencial OrderDetails->Orders después del merge';

-- 4. ESTADISTICAS DE LA ACTUALIZACION
INSERT INTO DQM_Descriptivos (
  proceso_id, tabla_nombre, campo_nombre,
  total_registros, registros_nulos, valores_unicos
)
SELECT 
  (SELECT proceso_id FROM DQM_Procesos WHERE nombre_proceso = 'Merge Orders Ingesta2'),
  'Orders_Nuevas',
  'insertadas',
  (SELECT COUNT(*) FROM TMP_Orders_ING2),
  0,
  (SELECT COUNT(DISTINCT orderID) FROM TMP_Orders_ING2)
UNION ALL
SELECT 
  (SELECT proceso_id FROM DQM_Procesos WHERE nombre_proceso = 'Merge OrderDetails Ingesta2'),
  'OrderDetails_Nuevos',
  'insertados',
  (SELECT COUNT(*) FROM TMP_OrderDetails_ING2),
  0,
  (SELECT COUNT(*) FROM TMP_OrderDetails_ING2);

-- 5. FINALIZAR PROCESOS
UPDATE DQM_Procesos 
SET estado = 'exitoso',
    registros_procesados = (SELECT COUNT(*) FROM TMP_Orders_ING2),
    observaciones = 'Nuevas orders insertadas exitosamente'
WHERE nombre_proceso = 'Merge Orders Ingesta2';

UPDATE DQM_Procesos 
SET estado = CASE 
  WHEN (SELECT resultado FROM DQM_Indicadores 
        WHERE proceso_id = (SELECT proceso_id FROM DQM_Procesos WHERE nombre_proceso = 'Merge OrderDetails Ingesta2')
        AND tipo_indicador = 'integridad') = 'aprobado' 
  THEN 'exitoso' 
  ELSE 'fallido' 
END,
registros_procesados = (SELECT COUNT(*) FROM TMP_OrderDetails_ING2),
observaciones = 'OrderDetails procesados con validación de integridad'
WHERE nombre_proceso = 'Merge OrderDetails Ingesta2';

-- Control final: ver totales actualizados
SELECT 
  'Orders' as tabla, COUNT(*) as total_registros 
FROM DWH_Fact_Orders
UNION ALL
SELECT 
  'OrderDetails' as tabla, COUNT(*) as total_registros 
FROM DWH_Fact_OrderDetails; 