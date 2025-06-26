-- CONTROLES DE INTEGRIDAD ENTRE TABLAS
-- Verificar que las relaciones sean correctas

-- Registrar inicio del proceso
INSERT INTO DQM_Procesos (
  nombre_proceso, tipo_proceso, tabla_origen, 
  estado, observaciones
) VALUES (
  'Control Calidad Integración', 'integracion', 'TMP_*', 
  'en_proceso', 'Iniciando controles de integridad referencial'
);

-- 1. VERIFICAR RELACIONES
-- Si falta relacion: crear registro generico o eliminar huerfanos

-- Verificar que todos los customerID en Orders existen en Customers
INSERT INTO DQM_Indicadores (
  proceso_id, tipo_indicador, tabla_nombre, campo_nombre,
  valor_indicador, umbral_minimo,
  resultado, descripcion
)
SELECT 
  (SELECT MAX(proceso_id) FROM DQM_Procesos),
  'integridad',
  'TMP_Orders',
  'customerID',
  ROUND(
    (COUNT(CASE WHEN o.customerID IN (SELECT customerID FROM TMP_Customers) THEN 1 END) * 100.0 / COUNT(*)), 2
  ) as integridad_customer_pct,
  100.0,
  CASE 
    WHEN (COUNT(CASE WHEN o.customerID IN (SELECT customerID FROM TMP_Customers) THEN 1 END) * 100.0 / COUNT(*)) >= 100.0 THEN 'aprobado'
    ELSE 'rechazado'
  END,
  'Integridad referencial: Orders->Customers'
FROM TMP_Orders o;

-- Verificar que todos los employeeID en Orders existen en Employees
INSERT INTO DQM_Indicadores (
  proceso_id, tipo_indicador, tabla_nombre, campo_nombre,
  valor_indicador, umbral_minimo,
  resultado, descripcion
)
SELECT 
  (SELECT MAX(proceso_id) FROM DQM_Procesos),
  'integridad',
  'TMP_Orders',
  'employeeID',
  ROUND(
    (COUNT(CASE WHEN o.employeeID IN (SELECT employeeID FROM TMP_Employees) THEN 1 END) * 100.0 / COUNT(*)), 2
  ) as integridad_employee_pct,
  100.0,
  CASE 
    WHEN (COUNT(CASE WHEN o.employeeID IN (SELECT employeeID FROM TMP_Employees) THEN 1 END) * 100.0 / COUNT(*)) >= 100.0 THEN 'aprobado'
    ELSE 'rechazado'
  END,
  'Integridad referencial: Orders->Employees'
FROM TMP_Orders o;

-- Verificar que todos los productID en OrderDetails existen en Products
INSERT INTO DQM_Indicadores (
  proceso_id, tipo_indicador, tabla_nombre, campo_nombre,
  valor_indicador, umbral_minimo,
  resultado, descripcion
)
SELECT 
  (SELECT MAX(proceso_id) FROM DQM_Procesos),
  'integridad',
  'TMP_OrderDetails',
  'productID',
  ROUND(
    (COUNT(CASE WHEN od.productID IN (SELECT productID FROM TMP_Products) THEN 1 END) * 100.0 / COUNT(*)), 2
  ) as integridad_product_pct,
  100.0,
  CASE 
    WHEN (COUNT(CASE WHEN od.productID IN (SELECT productID FROM TMP_Products) THEN 1 END) * 100.0 / COUNT(*)) >= 100.0 THEN 'aprobado'
    ELSE 'rechazado'
  END,
  'Integridad referencial: OrderDetails->Products'
FROM TMP_OrderDetails od;

-- Verificar que todos los orderID en OrderDetails existen en Orders
INSERT INTO DQM_Indicadores (
  proceso_id, tipo_indicador, tabla_nombre, campo_nombre,
  valor_indicador, umbral_minimo,
  resultado, descripcion
)
SELECT 
  (SELECT MAX(proceso_id) FROM DQM_Procesos),
  'integridad',
  'TMP_OrderDetails',
  'orderID',
  ROUND(
    (COUNT(CASE WHEN od.orderID IN (SELECT orderID FROM TMP_Orders) THEN 1 END) * 100.0 / COUNT(*)), 2
  ) as integridad_order_pct,
  100.0,
  CASE 
    WHEN (COUNT(CASE WHEN od.orderID IN (SELECT orderID FROM TMP_Orders) THEN 1 END) * 100.0 / COUNT(*)) >= 100.0 THEN 'aprobado'
    ELSE 'rechazado'
  END,
  'Integridad referencial: OrderDetails->Orders'
FROM TMP_OrderDetails od;

-- ========================================
-- 2. INDICADORES DE COMPARACIÓN
-- ========================================

-- Comparar totales de registros entre tablas relacionadas
INSERT INTO DQM_Indicadores (
  proceso_id, tipo_indicador, tabla_nombre, campo_nombre,
  valor_indicador, umbral_minimo,
  resultado, descripcion
)
SELECT 
  (SELECT MAX(proceso_id) FROM DQM_Procesos),
  'consistencia',
  'Comparación',
  'orders_vs_orderdetails',
  ROUND(
    (COUNT(DISTINCT od.orderID) * 100.0 / (SELECT COUNT(*) FROM TMP_Orders)), 2
  ) as cobertura_ordenes_pct,
  95.0,
  CASE 
    WHEN (COUNT(DISTINCT od.orderID) * 100.0 / (SELECT COUNT(*) FROM TMP_Orders)) >= 95.0 THEN 'aprobado'
    ELSE 'advertencia'
  END,
  'Cobertura de órdenes que tienen detalles'
FROM TMP_OrderDetails od;

-- Verificar consistencia de precios entre Products y OrderDetails
INSERT INTO DQM_Indicadores (
  proceso_id, tipo_indicador, tabla_nombre, campo_nombre,
  valor_indicador, umbral_minimo,
  resultado, descripcion
)
WITH precio_comparison AS (
  SELECT 
    od.productID,
    od.unitPrice as precio_orden,
    p.unitPrice as precio_producto,
    ABS(od.unitPrice - p.unitPrice) as diferencia
  FROM TMP_OrderDetails od
  JOIN TMP_Products p ON od.productID = p.productID
)
SELECT 
  (SELECT MAX(proceso_id) FROM DQM_Procesos),
  'consistencia',
  'Comparación',
  'precios_consistentes',
  ROUND(
    (COUNT(CASE WHEN diferencia < 5.0 THEN 1 END) * 100.0 / COUNT(*)), 2
  ) as precios_consistentes_pct,
  80.0,
  CASE 
    WHEN (COUNT(CASE WHEN diferencia < 5.0 THEN 1 END) * 100.0 / COUNT(*)) >= 80.0 THEN 'aprobado'
    ELSE 'advertencia'
  END,
  'Consistencia de precios entre Products y OrderDetails (diferencia < $5)'
FROM precio_comparison;

-- ========================================
-- 3. VALIDACIÓN DE JERARQUÍAS
-- ========================================

-- Verificar jerarquía de empleados (reportsTo)
INSERT INTO DQM_Indicadores (
  proceso_id, tipo_indicador, tabla_nombre, campo_nombre,
  valor_indicador, umbral_minimo,
  resultado, descripcion
)
SELECT 
  (SELECT MAX(proceso_id) FROM DQM_Procesos),
  'integridad',
  'TMP_Employees',
  'reportsTo',
  ROUND(
    (COUNT(CASE 
      WHEN reportsTo IS NULL OR reportsTo IN (SELECT employeeID FROM TMP_Employees) 
      THEN 1 END) * 100.0 / COUNT(*)), 2
  ) as jerarquia_valida_pct,
  100.0,
  CASE 
    WHEN (COUNT(CASE 
      WHEN reportsTo IS NULL OR reportsTo IN (SELECT employeeID FROM TMP_Employees) 
      THEN 1 END) * 100.0 / COUNT(*)) >= 100.0 THEN 'aprobado'
    ELSE 'rechazado'
  END,
  'Validación de jerarquía de empleados (reportsTo válido)'
FROM TMP_Employees;

-- Verificar jerarquía de territorios (regionID)
INSERT INTO DQM_Indicadores (
  proceso_id, tipo_indicador, tabla_nombre, campo_nombre,
  valor_indicador, umbral_minimo,
  resultado, descripcion
)
SELECT 
  (SELECT MAX(proceso_id) FROM DQM_Procesos),
  'integridad',
  'TMP_Territories',
  'regionID',
  ROUND(
    (COUNT(CASE WHEN t.regionID IN (SELECT regionID FROM TMP_Regions) THEN 1 END) * 100.0 / COUNT(*)), 2
  ) as territorios_regiones_pct,
  100.0,
  CASE 
    WHEN (COUNT(CASE WHEN t.regionID IN (SELECT regionID FROM TMP_Regions) THEN 1 END) * 100.0 / COUNT(*)) >= 100.0 THEN 'aprobado'
    ELSE 'rechazado'
  END,
  'Integridad referencial: Territories->Regions'
FROM TMP_Territories t;

-- ========================================
-- 4. VERIFICACIÓN DE CARDINALIDADES
-- ========================================

-- Verificar cardinalidad Orders : OrderDetails (1:N)
INSERT INTO DQM_Descriptivos (
  proceso_id, tabla_nombre, campo_nombre,
  total_registros, valores_unicos, promedio
)
SELECT 
  (SELECT MAX(proceso_id) FROM DQM_Procesos),
  'TMP_OrderDetails',
  'orderID_cardinalidad',
  COUNT(*) as total_detalles,
  COUNT(DISTINCT orderID) as ordenes_distintas,
  ROUND(COUNT(*) * 1.0 / COUNT(DISTINCT orderID), 2) as promedio_detalles_por_orden
FROM TMP_OrderDetails;

-- ========================================
-- 5. FINALIZAR PROCESO
-- ========================================

-- Actualizar estado final del proceso
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
observaciones = 'Control de integridad referencial completado'
WHERE proceso_id = (SELECT MAX(proceso_id) FROM DQM_Procesos);

-- ========================================
-- 6. CONSULTA DE RESULTADOS
-- ========================================

-- Ver resumen de controles de integración
SELECT 
  'INTEGRIDAD REFERENCIAL' as categoria,
  i.tabla_nombre,
  i.campo_nombre,
  i.valor_indicador || '%' as valor,
  i.umbral_minimo || '%' as umbral,
  i.resultado,
  i.descripcion
FROM DQM_Indicadores i
WHERE i.proceso_id = (SELECT MAX(proceso_id) FROM DQM_Procesos)
  AND i.tipo_indicador = 'integridad'

UNION ALL

SELECT 
  'CONSISTENCIA DATOS' as categoria,
  i.tabla_nombre,
  i.campo_nombre,
  i.valor_indicador || '%' as valor,
  i.umbral_minimo || '%' as umbral,
  i.resultado,
  i.descripcion
FROM DQM_Indicadores i
WHERE i.proceso_id = (SELECT MAX(proceso_id) FROM DQM_Procesos)
  AND i.tipo_indicador = 'consistencia'

ORDER BY categoria, resultado DESC; 