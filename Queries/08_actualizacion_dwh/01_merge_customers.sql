-- MERGE CUSTOMERS - Punto 9c
-- Altas, bajas y modificaciones con orden de prevalencia

-- Registrar proceso de actualización
INSERT INTO DQM_Procesos (
  nombre_proceso, tipo_proceso, tabla_origen, tabla_destino,
  estado, observaciones
) VALUES (
  'Merge Customers Ingesta2', 'merge', 'TMP_Customers_ING2', 'DWH_Dim_Customers',
  'en_proceso', 'Aplicando actualizaciones de customers'
);

-- 1. HISTORIZAR REGISTROS QUE VAN A CAMBIAR (Capa de Memoria)
-- Solo historizar si van a ser modificados
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
  'UPDATE' as tipo_operacion,
  (SELECT MAX(proceso_id) FROM DQM_Procesos) as proceso_id
FROM DWH_Dim_Customers dwh
WHERE dwh.customerID IN (SELECT customerID FROM TMP_Customers_ING2);

-- 2. APLICAR ACTUALIZACIONES (UPDATES)
-- Orden de prevalencia: Ingesta2 prevalece sobre datos existentes
UPDATE DWH_Dim_Customers 
SET 
  companyName = ing2.companyName,
  contactName = ing2.contactName,
  contactTitle = ing2.contactTitle,
  address = ing2.address,
  city = ing2.city,
  region = ing2.region,
  postalCode = ing2.postalCode,
  country = ing2.country,
  phone = ing2.phone,
  fax = ing2.fax
FROM TMP_Customers_ING2 ing2
WHERE DWH_Dim_Customers.customerID = ing2.customerID
  AND ing2.tipo_operacion = 'UPDATE';

-- 3. APLICAR ALTAS (INSERTS)
-- Solo insertar si no existen
INSERT INTO DWH_Dim_Customers
SELECT
  customerID, companyName, contactName, contactTitle, address,
  city, region, postalCode, country, phone, fax
FROM TMP_Customers_ING2 ing2
WHERE ing2.tipo_operacion = 'INSERT'
  AND ing2.customerID NOT IN (SELECT customerID FROM DWH_Dim_Customers);

-- 4. APLICAR BAJAS (DELETES) - si hubiera
-- En este caso no hay, pero sería:
/*
DELETE FROM DWH_Dim_Customers 
WHERE customerID IN (
  SELECT customerID FROM TMP_Customers_ING2 
  WHERE tipo_operacion = 'DELETE'
);
*/

-- 5. REGISTRAR ESTADISTICAS EN DQM
INSERT INTO DQM_Descriptivos (
  proceso_id, tabla_nombre, campo_nombre,
  total_registros, registros_nulos, valores_unicos
)
SELECT 
  (SELECT MAX(proceso_id) FROM DQM_Procesos),
  'Merge_Customers',
  'actualizaciones',
  (SELECT COUNT(*) FROM TMP_Customers_ING2 WHERE tipo_operacion = 'UPDATE'),
  (SELECT COUNT(*) FROM TMP_Customers_ING2 WHERE tipo_operacion = 'INSERT'), 
  (SELECT COUNT(*) FROM TMP_Customers_ING2 WHERE tipo_operacion = 'DELETE');

-- 6. FINALIZAR PROCESO
UPDATE DQM_Procesos 
SET estado = 'exitoso',
    registros_procesados = (SELECT COUNT(*) FROM TMP_Customers_ING2),
    observaciones = 'Merge de customers completado exitosamente'
WHERE proceso_id = (SELECT MAX(proceso_id) FROM DQM_Procesos);

-- Control final: verificar resultado
SELECT COUNT(*) as customers_total_final FROM DWH_Dim_Customers; 