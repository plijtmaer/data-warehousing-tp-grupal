-- ACTUALIZAR CAPA DE ENRIQUECIMIENTO - Punto 9f
-- Recalcular datos derivados afectados por Ingesta2

-- Registrar proceso de actualización de enriquecimiento
INSERT INTO DQM_Procesos (
  nombre_proceso, tipo_proceso, tabla_origen, tabla_destino,
  estado, observaciones
) VALUES (
  'Actualizar Enriquecimiento Ingesta2', 'enriquecimiento', 'DWH_*', 'ENR_*',
  'en_proceso', 'Recalculando métricas derivadas'
);

-- 1. ACTUALIZAR CUSTOMER ANALYTICS PARA CUSTOMERS MODIFICADOS
-- Recalcular métricas para customers que fueron actualizados o que tienen nuevas orders
DELETE FROM ENR_Customer_Analytics 
WHERE customerID IN (
  SELECT customerID FROM TMP_Customers_ING2
  UNION
  SELECT customerID FROM TMP_Orders_ING2
);

INSERT INTO ENR_Customer_Analytics (
  customerID, total_orders, total_spent, avg_order_value,
  first_order_date, last_order_date, customer_tier
)
SELECT 
  c.customerID,
  COUNT(o.orderID) as total_orders,
  COALESCE(SUM(od.totalPrice), 0) as total_spent,
  CASE 
    WHEN COUNT(o.orderID) > 0 
    THEN COALESCE(SUM(od.totalPrice), 0) / COUNT(o.orderID)
    ELSE 0 
  END as avg_order_value,
  MIN(o.orderDate) as first_order_date,
  MAX(o.orderDate) as last_order_date,
  CASE 
    WHEN COALESCE(SUM(od.totalPrice), 0) >= 5000 THEN 'VIP'
    WHEN COALESCE(SUM(od.totalPrice), 0) >= 2000 THEN 'Premium'
    WHEN COALESCE(SUM(od.totalPrice), 0) >= 500 THEN 'Regular'
    ELSE 'New'
  END as customer_tier
FROM DWH_Dim_Customers c
LEFT JOIN DWH_Fact_Orders o ON c.customerID = o.customerID
LEFT JOIN DWH_Fact_OrderDetails od ON o.orderID = od.orderID
WHERE c.customerID IN (
  SELECT customerID FROM TMP_Customers_ING2
  UNION
  SELECT customerID FROM TMP_Orders_ING2
)
GROUP BY c.customerID;

-- 2. ACTUALIZAR PRODUCT ANALYTICS PARA PRODUCTOS EN NUEVAS ORDERS
-- Solo para productos que aparecen en las nuevas orders
DELETE FROM ENR_Product_Analytics 
WHERE productID IN (
  SELECT DISTINCT productID FROM TMP_OrderDetails_ING2
);

INSERT INTO ENR_Product_Analytics (
  productID, total_quantity_sold, total_revenue, avg_selling_price,
  total_orders_containing_product, product_popularity_rank, product_status
)
WITH product_stats AS (
  SELECT 
    p.productID,
    COALESCE(SUM(od.quantity), 0) as total_quantity_sold,
    COALESCE(SUM(od.totalPrice), 0) as total_revenue,
    COALESCE(AVG(od.unitPrice), 0) as avg_selling_price,
    COUNT(DISTINCT od.orderID) as total_orders_containing_product
  FROM DWH_Dim_Products p
  LEFT JOIN DWH_Fact_OrderDetails od ON p.productID = od.productID
  WHERE p.productID IN (SELECT DISTINCT productID FROM TMP_OrderDetails_ING2)
  GROUP BY p.productID
)
SELECT 
  productID,
  total_quantity_sold,
  total_revenue,
  avg_selling_price,
  total_orders_containing_product,
  ROW_NUMBER() OVER (ORDER BY total_revenue DESC) as product_popularity_rank,
  CASE 
    WHEN total_revenue >= 10000 THEN 'Top Seller'
    WHEN total_revenue >= 2000 THEN 'Regular'
    ELSE 'Slow Moving'
  END as product_status
FROM product_stats;

-- 3. TEMPORAL ANALYTICS - COMENTADO
-- La tabla ENR_Temporal_Analytics no existe en el esquema original
-- Se mantiene el análisis temporal en las consultas directas

/*
-- Si se quisiera implementar, primero crear la tabla:
CREATE TABLE IF NOT EXISTS ENR_Temporal_Analytics (
  periodo_year INTEGER,
  periodo_month INTEGER,
  total_orders INTEGER,
  total_revenue REAL,
  avg_order_value REAL,
  growth_rate REAL,
  PRIMARY KEY (periodo_year, periodo_month)
);
*/

-- 4. ESTADISTICAS DE ACTUALIZACION DE ENRIQUECIMIENTO
INSERT INTO DQM_Descriptivos (
  proceso_id, tabla_nombre, campo_nombre,
  total_registros, registros_nulos, valores_unicos
)
SELECT 
  (SELECT MAX(proceso_id) FROM DQM_Procesos),
  'ENR_Customer_Analytics',
  'customers_actualizados',
  (SELECT COUNT(*) FROM ENR_Customer_Analytics),
  0,
  (SELECT COUNT(DISTINCT customerID) FROM ENR_Customer_Analytics)
UNION ALL
SELECT 
  (SELECT MAX(proceso_id) FROM DQM_Procesos),
  'ENR_Product_Analytics',
  'productos_actualizados',
  (SELECT COUNT(*) FROM ENR_Product_Analytics),
  0,
  (SELECT COUNT(DISTINCT productID) FROM ENR_Product_Analytics);

-- 5. FINALIZAR PROCESO DE ENRIQUECIMIENTO
UPDATE DQM_Procesos 
SET estado = 'exitoso',
    registros_procesados = (
      (SELECT COUNT(*) FROM ENR_Customer_Analytics) +
      (SELECT COUNT(*) FROM ENR_Product_Analytics)
    ),
    observaciones = 'Capa de enriquecimiento actualizada exitosamente'
WHERE proceso_id = (SELECT MAX(proceso_id) FROM DQM_Procesos);

-- 6. RESUMEN DE ACTUALIZACIONES DE ENRIQUECIMIENTO
SELECT 
  'Customer Analytics' as capa,
  COUNT(*) as registros_totales
FROM ENR_Customer_Analytics
UNION ALL
SELECT 
  'Product Analytics' as capa,
  COUNT(*) as registros_totales
FROM ENR_Product_Analytics; 