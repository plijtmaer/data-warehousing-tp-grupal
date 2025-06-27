-- CAPA DE MEMORIA PARA ACTUALIZACIONES - Punto 9e
-- Persistir historia de campos modificados en Ingesta2

-- Registrar proceso de historización
INSERT INTO DQM_Procesos (
  nombre_proceso, tipo_proceso, tabla_origen,
  estado, observaciones
) VALUES (
  'Historizacion Ingesta2', 'memoria', 'DWH_*',
  'en_proceso', 'Guardando historia de cambios'
);

-- 1. HISTORIZAR CUSTOMERS ANTES DE MODIFICACIONES
-- Esto ya se hace en el merge, pero verificamos que esté completo
INSERT INTO MEM_Customers_History (
  customerID, companyName, contactName, contactTitle, address, 
  city, region, postalCode, country, phone, fax,
  fecha_vigencia_desde, fecha_vigencia_hasta, tipo_operacion, proceso_id
)
SELECT 
  dwh.customerID, dwh.companyName, dwh.contactName, dwh.contactTitle, dwh.address,
  dwh.city, dwh.region, dwh.postalCode, dwh.country, dwh.phone, dwh.fax,
  DATE('now') as fecha_vigencia_desde,
  NULL as fecha_vigencia_hasta,
  'PRE_UPDATE_ING2' as tipo_operacion,
  (SELECT MAX(proceso_id) FROM DQM_Procesos) as proceso_id
FROM DWH_Dim_Customers dwh
WHERE dwh.customerID IN (SELECT customerID FROM TMP_Customers_ING2)
  AND dwh.customerID NOT IN (
    SELECT customerID FROM MEM_Customers_History 
    WHERE tipo_operacion = 'PRE_UPDATE_ING2'
  );

-- 2. CREAR TABLA DE SNAPSHOT SI NO EXISTE
-- Para documentar estado antes de actualizaciones
CREATE TABLE IF NOT EXISTS MEM_Orders_Snapshot (
  snapshot_id TEXT PRIMARY KEY,
  orderID INTEGER,
  customerID TEXT,
  employeeID INTEGER,
  shipperID INTEGER,
  orderDate DATE,
  requiredDate DATE,
  shippedDate DATE,
  freight REAL,
  fecha_snapshot DATE,
  motivo_snapshot TEXT,
  proceso_id INTEGER,
  FOREIGN KEY (proceso_id) REFERENCES DQM_Procesos(proceso_id)
);

-- Limpiar snapshot previo si existe (para permitir re-ejecución)
DELETE FROM MEM_Orders_Snapshot 
WHERE motivo_snapshot LIKE '%Ingesta2%';

-- Crear snapshot de estado actual antes de Ingesta2
INSERT INTO MEM_Orders_Snapshot (
  snapshot_id, orderID, customerID, employeeID, shipperID,
  orderDate, requiredDate, shippedDate, freight,
  fecha_snapshot, motivo_snapshot, proceso_id
)
SELECT 
  'ING2_PRE_' || orderID as snapshot_id,
  orderID, customerID, employeeID, shipperID,
  orderDate, requiredDate, shippedDate, freight,
  DATE('now') as fecha_snapshot,
  'Pre-actualización Ingesta2' as motivo_snapshot,
  (SELECT MAX(proceso_id) FROM DQM_Procesos) as proceso_id
FROM DWH_Fact_Orders
WHERE orderID IN (
  SELECT MAX(orderID) FROM DWH_Fact_Orders
  GROUP BY customerID
);

-- 3. REGISTRAR NUEVAS ORDERS PARA COMPARACION
-- Esto se ejecutará después del merge
INSERT INTO MEM_Orders_Snapshot (
  snapshot_id, orderID, customerID, employeeID, shipperID,
  orderDate, requiredDate, shippedDate, freight,
  fecha_snapshot, motivo_snapshot, proceso_id
)
SELECT 
  'ING2_POST_' || orderID as snapshot_id,
  orderID, customerID, employeeID, shipperID,
  orderDate, requiredDate, shippedDate, freight,
  DATE('now') as fecha_snapshot,
  'Post-actualización Ingesta2' as motivo_snapshot,
  (SELECT MAX(proceso_id) FROM DQM_Procesos) as proceso_id
FROM DWH_Fact_Orders
WHERE orderID IN (SELECT orderID FROM TMP_Orders_ING2);

-- 4. ANALISIS DE CAMBIOS REALIZADOS
-- Documentar qué cambió específicamente
INSERT INTO DQM_Descriptivos (
  proceso_id, tabla_nombre, campo_nombre,
  total_registros, registros_nulos, valores_unicos
)
SELECT 
  (SELECT MAX(proceso_id) FROM DQM_Procesos),
  'Customers_Modificados',
  'total_cambios',
  (SELECT COUNT(*) FROM MEM_Customers_History 
   WHERE tipo_operacion = 'PRE_UPDATE_ING2'),
  0,
  (SELECT COUNT(DISTINCT customerID) FROM MEM_Customers_History 
   WHERE tipo_operacion = 'PRE_UPDATE_ING2')
UNION ALL
SELECT 
  (SELECT MAX(proceso_id) FROM DQM_Procesos),
  'Orders_Nuevas',
  'total_adiciones',
  (SELECT COUNT(*) FROM DWH_Fact_Orders 
   WHERE orderID IN (SELECT orderID FROM TMP_Orders_ING2)),
  0,
  (SELECT COUNT(DISTINCT customerID) FROM DWH_Fact_Orders 
   WHERE orderID IN (SELECT orderID FROM TMP_Orders_ING2));

-- 5. CREAR VIEW PARA AUDITORIA DE CAMBIOS
CREATE VIEW IF NOT EXISTS V_Auditoria_Ingesta2 AS
SELECT 
  'Customers Modificados' as tipo_cambio,
  COUNT(*) as cantidad,
  GROUP_CONCAT(DISTINCT customerID) as registros_afectados
FROM MEM_Customers_History 
WHERE tipo_operacion = 'PRE_UPDATE_ING2'
UNION ALL
SELECT 
  'Orders Nuevas' as tipo_cambio,
  COUNT(*) as cantidad,
  MIN(orderID) || ' a ' || MAX(orderID) as registros_afectados
FROM DWH_Fact_Orders 
WHERE orderID IN (SELECT orderID FROM TMP_Orders_ING2)
UNION ALL
SELECT 
  'OrderDetails Nuevos' as tipo_cambio,
  COUNT(*) as cantidad,
  COUNT(DISTINCT orderID) || ' orders con detalles' as registros_afectados
FROM DWH_Fact_OrderDetails 
WHERE orderID IN (SELECT orderID FROM TMP_Orders_ING2);

-- 6. FINALIZAR PROCESO DE HISTORIZACIÓN
UPDATE DQM_Procesos 
SET estado = 'exitoso',
    registros_procesados = (
      (SELECT COUNT(*) FROM MEM_Customers_History WHERE tipo_operacion = 'PRE_UPDATE_ING2') +
      (SELECT COUNT(*) FROM MEM_Orders_Snapshot WHERE motivo_snapshot LIKE '%Ingesta2%')
    ),
    observaciones = 'Historia de cambios guardada exitosamente'
WHERE proceso_id = (SELECT MAX(proceso_id) FROM DQM_Procesos);

-- 7. MOSTRAR RESUMEN DE HISTORIZACIÓN
SELECT * FROM V_Auditoria_Ingesta2; 