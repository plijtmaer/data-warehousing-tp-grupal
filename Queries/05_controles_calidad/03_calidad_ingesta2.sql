-- CONTROLES DE CALIDAD PARA INGESTA2
-- Punto 9b: Repetir validaciones adaptadas para novedades

-- Registrar proceso DQM para Ingesta2
INSERT INTO DQM_Procesos (
  nombre_proceso, tipo_proceso, tabla_origen, 
  estado, observaciones
) VALUES (
  'Control Calidad Ingesta2', 'validacion', 'TMP_*_ING2', 
  'en_proceso', 'Validando datos de novedades'
);

-- 1. VERIFICAR DATOS DE CUSTOMERS NOVEDADES
-- Control: verificar que customers existe o es nuevo
INSERT INTO DQM_Indicadores (
  proceso_id, tipo_indicador, tabla_nombre, campo_nombre,
  valor_indicador, umbral_minimo,
  resultado, descripcion
)
SELECT 
  (SELECT MAX(proceso_id) FROM DQM_Procesos),
  'consistencia',
  'TMP_Customers_ING2',
  'customerID',
  ROUND(
    (COUNT(CASE WHEN c2.customerID IN (SELECT customerID FROM TMP_Customers) THEN 1 END) * 100.0 / COUNT(*)), 2
  ) as customers_existentes_pct,
  80.0,
  CASE 
    WHEN (COUNT(CASE WHEN c2.customerID IN (SELECT customerID FROM TMP_Customers) THEN 1 END) * 100.0 / COUNT(*)) >= 80.0 THEN 'aprobado'
    ELSE 'advertencia'
  END,
  'Porcentaje de customers que ya existen (para UPDATE)'
FROM TMP_Customers_ING2 c2;

-- 2. VERIFICAR NUEVAS ORDERS
-- Control: verificar que orderID no existen (son nuevas)
INSERT INTO DQM_Indicadores (
  proceso_id, tipo_indicador, tabla_nombre, campo_nombre,
  valor_indicador, umbral_minimo,
  resultado, descripcion
)
SELECT 
  (SELECT MAX(proceso_id) FROM DQM_Procesos),
  'unicidad',
  'TMP_Orders_ING2',
  'orderID',
  ROUND(
    (COUNT(CASE WHEN o2.orderID NOT IN (SELECT orderID FROM TMP_Orders) THEN 1 END) * 100.0 / COUNT(*)), 2
  ) as orders_nuevas_pct,
  90.0,
  CASE 
    WHEN (COUNT(CASE WHEN o2.orderID NOT IN (SELECT orderID FROM TMP_Orders) THEN 1 END) * 100.0 / COUNT(*)) >= 90.0 THEN 'aprobado'
    ELSE 'rechazado'
  END,
  'Porcentaje de orders que son realmente nuevas'
FROM TMP_Orders_ING2 o2;

-- 3. VERIFICAR INTEGRIDAD REFERENCIAL EN NOVEDADES
-- Control: verificar que customers en orders novedades existen
INSERT INTO DQM_Indicadores (
  proceso_id, tipo_indicador, tabla_nombre, campo_nombre,
  valor_indicador, umbral_minimo,
  resultado, descripcion
)
SELECT 
  (SELECT MAX(proceso_id) FROM DQM_Procesos),
  'integridad',
  'TMP_Orders_ING2',
  'customerID',
  ROUND(
    (COUNT(CASE 
      WHEN o2.customerID IN (SELECT customerID FROM TMP_Customers) 
        OR o2.customerID IN (SELECT customerID FROM TMP_Customers_ING2)
      THEN 1 END) * 100.0 / COUNT(*)), 2
  ) as integridad_customer_pct,
  100.0,
  CASE 
    WHEN (COUNT(CASE 
      WHEN o2.customerID IN (SELECT customerID FROM TMP_Customers) 
        OR o2.customerID IN (SELECT customerID FROM TMP_Customers_ING2)
      THEN 1 END) * 100.0 / COUNT(*)) >= 100.0 THEN 'aprobado'
    ELSE 'rechazado'
  END,
  'Integridad referencial Orders->Customers (incluye novedades)'
FROM TMP_Orders_ING2 o2;

-- 4. FINALIZAR PROCESO
UPDATE DQM_Procesos 
SET estado = CASE 
  WHEN (
    SELECT COUNT(*) FROM DQM_Indicadores 
    WHERE proceso_id = (SELECT MAX(proceso_id) FROM DQM_Procesos)
    AND resultado = 'rechazado'
  ) > 0 THEN 'fallido'
  WHEN (
    SELECT COUNT(*) FROM DQM_Indicadores 
    WHERE proceso_id = (SELECT MAX(proceso_id) FROM DQM_Procesos)
    AND resultado = 'advertencia'
  ) > 0 THEN 'advertencia'
  ELSE 'exitoso'
END,
observaciones = 'Control de calidad Ingesta2 completado'
WHERE proceso_id = (SELECT MAX(proceso_id) FROM DQM_Procesos);

-- 5. VER RESULTADOS
SELECT 
  i.tabla_nombre,
  i.campo_nombre,
  i.valor_indicador || '%' as valor,
  i.resultado,
  i.descripcion
FROM DQM_Indicadores i
WHERE i.proceso_id = (SELECT MAX(proceso_id) FROM DQM_Procesos)
ORDER BY i.resultado DESC; 