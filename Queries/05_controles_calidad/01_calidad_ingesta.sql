-- CONTROLES DE CALIDAD DE INGESTA
-- Verificar datos antes de cargar al DWH

-- Registrar proceso DQM

-- Registrar inicio del proceso de control de calidad
INSERT INTO DQM_Procesos (
  nombre_proceso, tipo_proceso, tabla_origen, 
  estado, observaciones
) VALUES (
  'Control Calidad Ingesta', 'validacion', 'TMP_*', 
  'en_proceso', 'Iniciando controles de calidad de ingesta'
);

-- 1. VERIFICAR DATOS FALTANTES
-- Si faltan datos: crear registros con valores por defecto o rechazar tabla

-- Clientes: verificar campos obligatorios
INSERT INTO DQM_Indicadores (
  proceso_id, tipo_indicador, tabla_nombre, campo_nombre,
  valor_indicador, umbral_minimo, 
  resultado, descripcion
)
SELECT 
  (SELECT MAX(proceso_id) FROM DQM_Procesos),
  'completitud',
  'TMP_Customers',
  'customerID',
  ROUND(
    (COUNT(customerID) * 100.0 / COUNT(*)), 2
  ) as completitud_pct,
  100.0,
  CASE 
    WHEN (COUNT(customerID) * 100.0 / COUNT(*)) >= 100.0 THEN 'aprobado'
    ELSE 'rechazado'
  END,
  'Verificación de customerID obligatorio'
FROM TMP_Customers;

-- Productos: verificar precios válidos
INSERT INTO DQM_Indicadores (
  proceso_id, tipo_indicador, tabla_nombre, campo_nombre,
  valor_indicador, umbral_minimo,
  resultado, descripcion
)
SELECT 
  (SELECT MAX(proceso_id) FROM DQM_Procesos),
  'consistencia',
  'TMP_Products',
  'unitPrice',
  ROUND(
    (COUNT(CASE WHEN unitPrice > 0 THEN 1 END) * 100.0 / COUNT(*)), 2
  ) as precios_validos_pct,
  95.0,
  CASE 
    WHEN (COUNT(CASE WHEN unitPrice > 0 THEN 1 END) * 100.0 / COUNT(*)) >= 95.0 THEN 'aprobado'
    ELSE 'rechazado'
  END,
  'Verificación de precios unitarios positivos'
FROM TMP_Products;

-- 2. VERIFICAR FORMATOS
-- Si formato malo: convertir a formato correcto o marcar como error

-- Fechas en formato válido
INSERT INTO DQM_Indicadores (
  proceso_id, tipo_indicador, tabla_nombre, campo_nombre,
  valor_indicador, umbral_minimo,
  resultado, descripcion
)
SELECT 
  (SELECT MAX(proceso_id) FROM DQM_Procesos),
  'precision',
  'TMP_Orders',
  'orderDate',
  ROUND(
    (COUNT(CASE WHEN DATE(orderDate) IS NOT NULL THEN 1 END) * 100.0 / COUNT(*)), 2
  ) as fechas_validas_pct,
  98.0,
  CASE 
    WHEN (COUNT(CASE WHEN DATE(orderDate) IS NOT NULL THEN 1 END) * 100.0 / COUNT(*)) >= 98.0 THEN 'aprobado'
    ELSE 'rechazado'
  END,
  'Verificación de formato de fechas de pedidos'
FROM TMP_Orders;

-- 3. VERIFICAR VALORES EXTREMOS
-- Si hay outliers: limitar valores o revisar manualmente

-- Cantidades extremas en pedidos
INSERT INTO DQM_Indicadores (
  proceso_id, tipo_indicador, tabla_nombre, campo_nombre,
  valor_indicador, umbral_minimo,
  resultado, descripcion
)
SELECT 
  (SELECT MAX(proceso_id) FROM DQM_Procesos),
  'consistencia',
  'TMP_OrderDetails',
  'quantity',
  ROUND(
    (COUNT(CASE WHEN quantity BETWEEN 1 AND 1000 THEN 1 END) * 100.0 / COUNT(*)), 2
  ) as cantidades_normales_pct,
  90.0,
  CASE 
    WHEN (COUNT(CASE WHEN quantity BETWEEN 1 AND 1000 THEN 1 END) * 100.0 / COUNT(*)) >= 90.0 THEN 'aprobado'
    ELSE 'advertencia'
  END,
  'Verificación de cantidades en rango normal (1-1000)'
FROM TMP_OrderDetails;

-- Descuentos válidos (0-100%)
INSERT INTO DQM_Indicadores (
  proceso_id, tipo_indicador, tabla_nombre, campo_nombre,
  valor_indicador, umbral_minimo,
  resultado, descripcion
)
SELECT 
  (SELECT MAX(proceso_id) FROM DQM_Procesos),
  'precision',
  'TMP_OrderDetails',
  'discount',
  ROUND(
    (COUNT(CASE WHEN discount BETWEEN 0 AND 1 THEN 1 END) * 100.0 / COUNT(*)), 2
  ) as descuentos_validos_pct,
  95.0,
  CASE 
    WHEN (COUNT(CASE WHEN discount BETWEEN 0 AND 1 THEN 1 END) * 100.0 / COUNT(*)) >= 95.0 THEN 'aprobado'
    ELSE 'rechazado'
  END,
  'Verificación de descuentos en rango válido (0-1)'
FROM TMP_OrderDetails;

-- 4. VERIFICAR DUPLICADOS
-- Si hay duplicados: quedarse con el primero o rechazar

-- Verificar duplicados en claves primarias
INSERT INTO DQM_Indicadores (
  proceso_id, tipo_indicador, tabla_nombre, campo_nombre,
  valor_indicador, umbral_minimo,
  resultado, descripcion
)
SELECT 
  (SELECT MAX(proceso_id) FROM DQM_Procesos),
  'unicidad',
  'TMP_Customers',
  'customerID',
  ROUND(
    (COUNT(DISTINCT customerID) * 100.0 / COUNT(*)), 2
  ) as unicidad_pct,
  100.0,
  CASE 
    WHEN (COUNT(DISTINCT customerID) * 100.0 / COUNT(*)) >= 100.0 THEN 'aprobado'
    ELSE 'rechazado'
  END,
  'Verificación de unicidad en customerID'
FROM TMP_Customers;

-- 5. ESTADISTICAS DE LOS DATOS

-- Descriptivos de la tabla de productos
INSERT INTO DQM_Descriptivos (
  proceso_id, tabla_nombre, campo_nombre,
  total_registros, registros_nulos, valores_unicos,
  valor_minimo, valor_maximo, promedio
)
SELECT 
  (SELECT MAX(proceso_id) FROM DQM_Procesos),
  'TMP_Products',
  'unitPrice',
  COUNT(*),
  COUNT(*) - COUNT(unitPrice),
  COUNT(DISTINCT unitPrice),
  CAST(MIN(unitPrice) AS TEXT),
  CAST(MAX(unitPrice) AS TEXT),
  ROUND(AVG(unitPrice), 2)
FROM TMP_Products;

-- 6. FINALIZAR Y DECIDIR

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
observaciones = 'Control de calidad de ingesta completado'
WHERE proceso_id = (SELECT MAX(proceso_id) FROM DQM_Procesos);

-- 7. VER RESULTADOS

-- Ver resumen de controles ejecutados
SELECT 
  i.tipo_indicador,
  i.tabla_nombre,
  i.campo_nombre,
  i.valor_indicador || '%' as valor,
  i.umbral_minimo || '%' as umbral,
  i.resultado,
  i.descripcion
FROM DQM_Indicadores i
WHERE i.proceso_id = (SELECT MAX(proceso_id) FROM DQM_Procesos)
ORDER BY i.resultado DESC, i.tipo_indicador, i.tabla_nombre; 