-- VALIDAR STG_WorldData2023
-- Controles de calidad post-limpieza

-- Registrar proceso de validación
INSERT INTO DQM_Procesos (
  nombre_proceso, tipo_proceso, tabla_origen, 
  estado, observaciones
) VALUES (
  'Validación STG_WorldData2023', 'validacion', 'STG_WorldData2023', 
  'en_proceso', 'Verificando calidad de datos post-limpieza'
);

-- 1. CONTROLES BÁSICOS DE CONTEO
INSERT INTO DQM_Indicadores (
  proceso_id, tipo_indicador, tabla_nombre, campo_nombre,
  valor_indicador, umbral_minimo,
  resultado, descripcion
)
SELECT 
  (SELECT MAX(proceso_id) FROM DQM_Procesos),
  'completitud',
  'STG_WorldData2023',
  'total_registros',
  COUNT(*),
  195.0,
  CASE WHEN COUNT(*) >= 195 THEN 'aprobado' ELSE 'rechazado' END,
  'Verificar que se mantienen todos los países después de la limpieza'
FROM STG_WorldData2023;

-- 2. VALIDAR TRANSFORMACIÓN DE GDP
INSERT INTO DQM_Indicadores (
  proceso_id, tipo_indicador, tabla_nombre, campo_nombre,
  valor_indicador, umbral_minimo,
  resultado, descripcion
)
SELECT 
  (SELECT MAX(proceso_id) FROM DQM_Procesos),
  'consistencia',
  'STG_WorldData2023',
  'gdp_numeric',
  ROUND(
    (COUNT(CASE WHEN gdp IS NOT NULL AND typeof(gdp) = 'real' THEN 1 END) * 100.0 / COUNT(*)), 2
  ),
  95.0,
  CASE 
    WHEN (COUNT(CASE WHEN gdp IS NOT NULL AND typeof(gdp) = 'real' THEN 1 END) * 100.0 / COUNT(*)) >= 95.0 
    THEN 'aprobado' 
    ELSE 'rechazado' 
  END,
  'GDP convertido correctamente a numérico (eliminar $ y comas)'
FROM STG_WorldData2023;

-- 3. VALIDAR TRANSFORMACIÓN DE POBLACIÓN
INSERT INTO DQM_Indicadores (
  proceso_id, tipo_indicador, tabla_nombre, campo_nombre,
  valor_indicador, umbral_minimo,
  resultado, descripcion
)
SELECT 
  (SELECT MAX(proceso_id) FROM DQM_Procesos),
  'consistencia',
  'STG_WorldData2023',
  'population_numeric',
  ROUND(
    (COUNT(CASE WHEN population IS NOT NULL AND typeof(population) = 'integer' THEN 1 END) * 100.0 / COUNT(*)), 2
  ),
  95.0,
  CASE 
    WHEN (COUNT(CASE WHEN population IS NOT NULL AND typeof(population) = 'integer' THEN 1 END) * 100.0 / COUNT(*)) >= 95.0 
    THEN 'aprobado' 
    ELSE 'rechazado' 
  END,
  'Población convertida correctamente a entero (eliminar comas)'
FROM STG_WorldData2023;

-- 4. VALIDAR RANGOS VÁLIDOS
INSERT INTO DQM_Indicadores (
  proceso_id, tipo_indicador, tabla_nombre, campo_nombre,
  valor_indicador, umbral_minimo,
  resultado, descripcion
)
SELECT 
  (SELECT MAX(proceso_id) FROM DQM_Procesos),
  'consistencia',
  'STG_WorldData2023',
  'life_expectancy_range',
  ROUND(
    (COUNT(CASE WHEN life_expectancy BETWEEN 30 AND 90 THEN 1 END) * 100.0 / 
     COUNT(CASE WHEN life_expectancy IS NOT NULL THEN 1 END)), 2
  ),
  95.0,
  CASE 
    WHEN (COUNT(CASE WHEN life_expectancy BETWEEN 30 AND 90 THEN 1 END) * 100.0 / 
          COUNT(CASE WHEN life_expectancy IS NOT NULL THEN 1 END)) >= 95.0 
    THEN 'aprobado' 
    ELSE 'rechazado' 
  END,
  'Esperanza de vida en rango válido (30-90 años)'
FROM STG_WorldData2023;

-- 5. SCORE DE CALIDAD PROMEDIO
INSERT INTO DQM_Indicadores (
  proceso_id, tipo_indicador, tabla_nombre, campo_nombre,
  valor_indicador, umbral_minimo,
  resultado, descripcion
)
SELECT 
  (SELECT MAX(proceso_id) FROM DQM_Procesos),
  'calidad',
  'STG_WorldData2023',
  'avg_quality_score',
  ROUND(AVG(stg_data_quality_score), 2),
  0.7,
  CASE 
    WHEN AVG(stg_data_quality_score) >= 0.7 THEN 'aprobado' 
    ELSE 'rechazado' 
  END,
  'Score promedio de calidad de datos >= 70%'
FROM STG_WorldData2023;

-- 6. VALIDAR CORRECCIONES DE PAÍSES
INSERT INTO DQM_Indicadores (
  proceso_id, tipo_indicador, tabla_nombre, campo_nombre,
  valor_indicador, umbral_minimo,
  resultado, descripcion
)
SELECT 
  (SELECT MAX(proceso_id) FROM DQM_Procesos),
  'transformacion',
  'STG_WorldData2023',
  'paises_estandarizados',
  (SELECT COUNT(*) FROM STG_WorldData2023 WHERE country IN ('USA', 'UK', 'Ireland')),
  3.0,
  CASE 
    WHEN (SELECT COUNT(*) FROM STG_WorldData2023 WHERE country IN ('USA', 'UK', 'Ireland')) >= 3 
    THEN 'aprobado' 
    ELSE 'rechazado' 
  END,
  'Países correctamente estandarizados: USA, UK, Ireland'
FROM STG_WorldData2023 LIMIT 1;

-- 7. VALIDAR CORRECCIONES DE ENCODING
INSERT INTO DQM_Indicadores (
  proceso_id, tipo_indicador, tabla_nombre, campo_nombre,
  valor_indicador, umbral_minimo,
  resultado, descripcion
)
SELECT 
  (SELECT MAX(proceso_id) FROM DQM_Procesos),
  'transformacion',
  'STG_WorldData2023',
  'encoding_corregido',
  (SELECT COUNT(*) FROM STG_WorldData2023 WHERE capital_major_city NOT LIKE '%�%' AND largest_city NOT LIKE '%�%'),
  194.0,
  CASE 
    WHEN (SELECT COUNT(*) FROM STG_WorldData2023 WHERE capital_major_city LIKE '%�%' OR largest_city LIKE '%�%') = 0 
    THEN 'aprobado' 
    ELSE 'rechazado' 
  END,
  'Problemas de encoding UTF-8 corregidos en ciudades'
FROM STG_WorldData2023 LIMIT 1;

-- 8. COMPARACIÓN CON ORIGEN
INSERT INTO DQM_Descriptivos (
  proceso_id, tabla_nombre, campo_nombre,
  total_registros, registros_nulos, valores_unicos
)
SELECT 
  (SELECT MAX(proceso_id) FROM DQM_Procesos),
  'Comparación TMP vs STG',
  'registros_totales',
  (SELECT COUNT(*) FROM STG_WorldData2023),
  0,
  (SELECT COUNT(*) FROM TMP_WorldData2023)
UNION ALL
SELECT 
  (SELECT MAX(proceso_id) FROM DQM_Procesos),
  'STG_WorldData2023',
  'gdp_convertidos',
  COUNT(CASE WHEN gdp IS NOT NULL THEN 1 END),
  COUNT(CASE WHEN gdp IS NULL THEN 1 END),
  COUNT(DISTINCT CASE WHEN gdp IS NOT NULL THEN country END)
FROM STG_WorldData2023
UNION ALL
SELECT 
  (SELECT MAX(proceso_id) FROM DQM_Procesos),
  'STG_WorldData2023',
  'population_convertidas',
  COUNT(CASE WHEN population IS NOT NULL THEN 1 END),
  COUNT(CASE WHEN population IS NULL THEN 1 END),
  COUNT(DISTINCT CASE WHEN population IS NOT NULL THEN country END)
FROM STG_WorldData2023;

-- 9. EJEMPLOS DE TRANSFORMACIONES EXITOSAS

SELECT 'EJEMPLOS DE CORRECCIONES DE PAÍSES:' as validacion;
SELECT 
    'Estandarización USA:' as tipo,
    (SELECT COUNT(*) FROM STG_WorldData2023 WHERE country = 'USA') as stg_count,
    (SELECT COUNT(*) FROM TMP_WorldData2023 WHERE country = 'United States') as tmp_count
UNION ALL
SELECT 
    'Estandarización UK:',
    (SELECT COUNT(*) FROM STG_WorldData2023 WHERE country = 'UK'),
    (SELECT COUNT(*) FROM TMP_WorldData2023 WHERE country = 'United Kingdom')
UNION ALL
SELECT 
    'Estandarización Ireland:',
    (SELECT COUNT(*) FROM STG_WorldData2023 WHERE country = 'Ireland'),
    (SELECT COUNT(*) FROM TMP_WorldData2023 WHERE country = 'Republic of Ireland');

SELECT 'EJEMPLOS DE CORRECCIONES DE ENCODING:' as validacion;
SELECT 
    country,
    capital_major_city as capital_corregida,
    largest_city as largest_corregida
FROM STG_WorldData2023 
WHERE country IN ('Brazil', 'Colombia', 'Costa Rica', 'Iceland', 'Paraguay')
ORDER BY country;

SELECT 'Ejemplos de transformaciones GDP exitosas:' as validacion;
SELECT country, 
       (SELECT gdp FROM TMP_WorldData2023 WHERE country = CASE 
           WHEN s.country = 'USA' THEN 'United States'
           WHEN s.country = 'UK' THEN 'United Kingdom'
           WHEN s.country = 'Ireland' THEN 'Republic of Ireland'
           ELSE s.country END) as gdp_original,
       s.gdp as gdp_limpio,
       s.stg_data_quality_score
FROM STG_WorldData2023 s 
WHERE s.gdp IS NOT NULL 
ORDER BY s.gdp DESC 
LIMIT 5;

SELECT 'Ejemplos de transformaciones población exitosas:' as validacion;
SELECT country,
       (SELECT population FROM TMP_WorldData2023 WHERE country = CASE 
           WHEN s.country = 'USA' THEN 'United States'
           WHEN s.country = 'UK' THEN 'United Kingdom'
           WHEN s.country = 'Ireland' THEN 'Republic of Ireland'
           ELSE s.country END) as population_original,
       s.population as population_limpia,
       s.stg_data_quality_score
FROM STG_WorldData2023 s 
WHERE s.population IS NOT NULL 
ORDER BY s.population DESC 
LIMIT 5;

-- Finalizar proceso
UPDATE DQM_Procesos 
SET estado = CASE 
  WHEN (SELECT COUNT(*) FROM DQM_Indicadores 
        WHERE proceso_id = (SELECT MAX(proceso_id) FROM DQM_Procesos WHERE nombre_proceso = 'Validación STG_WorldData2023')
        AND resultado = 'rechazado') = 0 
  THEN 'exitoso' 
  ELSE 'fallido' 
END,
registros_procesados = (SELECT COUNT(*) FROM STG_WorldData2023),
observaciones = 'Validación completada - datos listos para DWH'
WHERE nombre_proceso = 'Validación STG_WorldData2023'; 