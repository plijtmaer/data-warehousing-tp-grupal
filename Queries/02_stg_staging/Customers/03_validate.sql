-- VALIDAR STG_Customers
-- Controles de calidad post-staging

-- Registrar proceso de validación
INSERT INTO DQM_Procesos (
  nombre_proceso, tipo_proceso, tabla_origen, 
  estado, observaciones
) VALUES (
  'Validación STG_Customers', 'validacion', 'STG_Customers', 
  'en_proceso', 'Verificando calidad datos customers staging'
);

-- 1. CONTROL DE CONTEO
INSERT INTO DQM_Indicadores (
  proceso_id, tipo_indicador, tabla_nombre, campo_nombre,
  valor_indicador, umbral_minimo,
  resultado, descripcion
)
SELECT 
  (SELECT MAX(proceso_id) FROM DQM_Procesos),
  'completitud',
  'STG_Customers',
  'total_registros',
  COUNT(*),
  91.0,
  CASE WHEN COUNT(*) >= 91 THEN 'aprobado' ELSE 'rechazado' END,
  'Verificar que se mantienen todos los customers después del staging'
FROM STG_Customers;

-- 2. CAMPOS OBLIGATORIOS
INSERT INTO DQM_Indicadores (
  proceso_id, tipo_indicador, tabla_nombre, campo_nombre,
  valor_indicador, umbral_minimo,
  resultado, descripcion
)
SELECT 
  (SELECT MAX(proceso_id) FROM DQM_Procesos),
  'completitud',
  'STG_Customers',
  'customerID_completo',
  ROUND(
    (COUNT(CASE WHEN customerID IS NOT NULL AND customerID != '' THEN 1 END) * 100.0 / COUNT(*)), 2
  ),
  100.0,
  CASE 
    WHEN (COUNT(CASE WHEN customerID IS NOT NULL AND customerID != '' THEN 1 END) * 100.0 / COUNT(*)) >= 100.0 
    THEN 'aprobado' 
    ELSE 'rechazado' 
  END,
  'CustomerID obligatorio debe estar completo'
FROM STG_Customers;

-- 3. CALIDAD DE DATOS
INSERT INTO DQM_Indicadores (
  proceso_id, tipo_indicador, tabla_nombre, campo_nombre,
  valor_indicador, umbral_minimo,
  resultado, descripcion
)
SELECT 
  (SELECT MAX(proceso_id) FROM DQM_Procesos),
  'calidad',
  'STG_Customers',
  'avg_quality_score',
  ROUND(AVG(stg_data_quality_score), 2),
  0.9,
  CASE 
    WHEN AVG(stg_data_quality_score) >= 0.9 THEN 'aprobado' 
    ELSE 'rechazado' 
  END,
  'Score promedio de calidad >= 90% (datos ya limpios)'
FROM STG_Customers;

-- 4. INTEGRIDAD CON ORIGEN
INSERT INTO DQM_Descriptivos (
  proceso_id, tabla_nombre, campo_nombre,
  total_registros, registros_nulos, valores_unicos
)
SELECT 
  (SELECT MAX(proceso_id) FROM DQM_Procesos),
  'Comparación TMP vs STG',
  'customers_total',
  (SELECT COUNT(*) FROM STG_Customers),
  0,
  (SELECT COUNT(*) FROM TMP_Customers);

-- Finalizar proceso
UPDATE DQM_Procesos 
SET estado = CASE 
  WHEN (SELECT COUNT(*) FROM DQM_Indicadores 
        WHERE proceso_id = (SELECT MAX(proceso_id) FROM DQM_Procesos WHERE nombre_proceso = 'Validación STG_Customers')
        AND resultado = 'rechazado') = 0 
  THEN 'exitoso' 
  ELSE 'fallido' 
END,
registros_procesados = (SELECT COUNT(*) FROM STG_Customers),
observaciones = 'Validación completada - customers listos para DWH'
WHERE nombre_proceso = 'Validación STG_Customers'; 