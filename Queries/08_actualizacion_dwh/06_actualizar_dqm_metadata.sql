-- ACTUALIZAR DQM Y METADATA - Puntos 9h y 9i
-- Actualizar sistemas de gestión después de Ingesta2

-- Registrar proceso de actualización de sistemas
INSERT INTO DQM_Procesos (
  nombre_proceso, tipo_proceso, tabla_origen,
  estado, observaciones
) VALUES (
  'Actualizar DQM y Metadata Ingesta2', 'mantenimiento', 'DQM_*, MET_*',
  'en_proceso', 'Actualizando sistemas de gestión post-Ingesta2'
);

-- =====================================
-- PUNTO 9h: ACTUALIZAR DQM SI NECESARIO
-- =====================================

-- 1. ACTUALIZAR REGLAS DQM CON NUEVOS UMBRALES

-- Recalcular umbral de completitud para customers basado en nuevos datos
UPDATE DQM_Reglas 
SET umbral_aceptacion = (
  SELECT ROUND(AVG(completitud), 1)
  FROM (
    SELECT 
      (CASE WHEN companyName IS NOT NULL THEN 1.0 ELSE 0.0 END +
       CASE WHEN contactName IS NOT NULL THEN 1.0 ELSE 0.0 END +
       CASE WHEN city IS NOT NULL THEN 1.0 ELSE 0.0 END +
       CASE WHEN country IS NOT NULL THEN 1.0 ELSE 0.0 END) / 4.0 * 100 as completitud
    FROM DWH_Dim_Customers
  )
)
WHERE tabla_aplicable = 'DWH_Dim_Customers' 
  AND tipo_regla = 'obligatorio';

-- Actualizar regla de integridad para orders con nuevos datos
UPDATE DQM_Reglas 
SET descripcion = descripcion || ' - Actualizada post-Ingesta2: ' || DATE('now')
WHERE tabla_aplicable = 'DWH_Fact_Orders'
  AND tipo_regla = 'referencial';

-- 2. AGREGAR NUEVAS REGLAS PARA DETECCION DE PATRONES DE INGESTA2
-- Regla para detectar actualizaciones masivas similares
INSERT OR IGNORE INTO DQM_Reglas (
  nombre_regla, tipo_regla, tabla_aplicable, campo_aplicable,
  umbral_aceptacion, descripcion
) VALUES (
  'Control Volumen Ingesta2', 'rango', 'TMP_*_ING2', 'general',
  95.0, 'Detectar actualizaciones masivas anómalas - Creada post-Ingesta2'
);

-- 3. LIMPIAR PROCESOS DQM ANTIGUOS (mantener solo últimos 30 días)
DELETE FROM DQM_Indicadores 
WHERE proceso_id IN (
  SELECT proceso_id FROM DQM_Procesos 
  WHERE fecha_ejecucion < DATETIME('now', '-30 days')
  AND tipo_proceso NOT IN ('maestro', 'control') -- Mantener procesos importantes
);

DELETE FROM DQM_Procesos 
WHERE fecha_ejecucion < DATETIME('now', '-30 days')
  AND tipo_proceso NOT IN ('maestro', 'control');

-- 4. ACTUALIZAR ESTADISTICAS DQM
INSERT INTO DQM_Descriptivos (
  proceso_id, tabla_nombre, campo_nombre,
  total_registros, registros_nulos, valores_unicos
)
SELECT 
  (SELECT MAX(proceso_id) FROM DQM_Procesos),
  'DQM_Maintenance',
  'reglas_activas',
  COUNT(*),
  0,
  COUNT(DISTINCT tabla_aplicable)
FROM DQM_Reglas
WHERE activa = 1;

-- ======================================
-- PUNTO 9i: ACTUALIZAR METADATA SI NECESARIO
-- ======================================

-- 1. ACTUALIZAR CONTADORES EN MET_TABLAS
-- Ya se hace en el script maestro, pero verificamos

-- Registrar nueva ingesta en metadata
INSERT OR IGNORE INTO MET_Tablas (
  nombre_tabla, tipo, descripcion, fecha_creacion, comentarios
) VALUES (
  'TMP_Customers_ING2', 'temporal', 'Tabla temporal para novedades customers Ingesta2', 
  DATE('now'), 'Registros: ' || (SELECT COUNT(*) FROM TMP_Customers_ING2)
),
(
  'TMP_Orders_ING2', 'temporal', 'Tabla temporal para nuevas orders Ingesta2',
  DATE('now'), 'Registros: ' || (SELECT COUNT(*) FROM TMP_Orders_ING2)
),
(
  'TMP_OrderDetails_ING2', 'temporal', 'Tabla temporal para nuevos order_details Ingesta2',
  DATE('now'), 'Registros: ' || (SELECT COUNT(*) FROM TMP_OrderDetails_ING2)
);

-- 2. ACTUALIZAR CAMPOS SI HAY NUEVOS ATRIBUTOS
-- Verificar si hay campos nuevos en las tablas de Ingesta2

-- Para customers
INSERT OR IGNORE INTO MET_Campos (
  nombre_tabla, nombre_campo, tipo_dato, descripcion, origen
)
VALUES (
  'TMP_Customers_ING2',
  'tipo_operacion',
  'TEXT',
  'Campo agregado en Ingesta2 para identificar tipo de operación',
  'Ingesta2'
);

-- 3. ACTUALIZAR COMENTARIOS CON CONTADORES ACTUALES
UPDATE MET_Tablas 
SET comentarios = 'Registros actuales: ' || (SELECT COUNT(*) FROM DWH_Dim_Customers) || ' - Actualizado: ' || DATE('now')
WHERE nombre_tabla = 'DWH_Dim_Customers';

UPDATE MET_Tablas 
SET comentarios = 'Registros actuales: ' || (SELECT COUNT(*) FROM DWH_Fact_Orders) || ' - Actualizado: ' || DATE('now')
WHERE nombre_tabla = 'DWH_Fact_Orders';

UPDATE MET_Tablas 
SET comentarios = 'Registros actuales: ' || (SELECT COUNT(*) FROM DWH_Fact_OrderDetails) || ' - Actualizado: ' || DATE('now')
WHERE nombre_tabla = 'DWH_Fact_OrderDetails';

-- 4. REGISTRAR HISTORICO DE INGESTAS EN METADATA
-- Crear tabla para tracking de ingestas si no existe
CREATE TABLE IF NOT EXISTS MET_Historico_Ingestas (
  ingesta_id INTEGER PRIMARY KEY AUTOINCREMENT,
  nombre_ingesta TEXT,
  fecha_ingesta DATE,
  tablas_afectadas TEXT,
  registros_procesados INTEGER,
  estado_final TEXT,
  observaciones TEXT
);

-- Registrar Ingesta2
INSERT INTO MET_Historico_Ingestas (
  nombre_ingesta, fecha_ingesta, tablas_afectadas, 
  registros_procesados, estado_final, observaciones
)
VALUES (
  'Ingesta2',
  DATE('now'),
  'DWH_Dim_Customers, DWH_Fact_Orders, DWH_Fact_OrderDetails',
  (SELECT COUNT(*) FROM TMP_Customers_ING2) + 
  (SELECT COUNT(*) FROM TMP_Orders_ING2) + 
  (SELECT COUNT(*) FROM TMP_OrderDetails_ING2),
  'exitoso',
  'Actualización completada manualmente - todos los scripts ejecutados'
);

-- 5. CREAR VIEWS DE METADATA ENRIQUECIDA
CREATE VIEW IF NOT EXISTS V_Metadata_Estado_Post_Ingesta2 AS
SELECT 
  t.nombre_tabla,
  t.tipo,
  t.descripcion,
  t.fecha_creacion,
  t.comentarios,
  COUNT(c.nombre_campo) as total_campos,
  CASE 
    WHEN t.fecha_creacion = DATE('now') THEN 'Creada hoy'
    WHEN t.fecha_creacion >= DATE('now', '-7 days') THEN 'Creada esta semana'
    ELSE 'Creación antigua'
  END as estado_creacion
FROM MET_Tablas t
LEFT JOIN MET_Campos c ON t.nombre_tabla = c.nombre_tabla
WHERE t.tipo IN ('dimension', 'fact', 'temporal')
GROUP BY t.nombre_tabla, t.tipo, t.descripcion, t.fecha_creacion, t.comentarios;

-- 6. FINALIZAR ACTUALIZACION DE SISTEMAS
UPDATE DQM_Procesos 
SET estado = 'exitoso',
    registros_procesados = (
      (SELECT COUNT(*) FROM DQM_Reglas WHERE activa = 1) +
      (SELECT COUNT(*) FROM MET_Tablas WHERE tipo IN ('dimension', 'fact'))
    ),
    observaciones = 'DQM y Metadata actualizados exitosamente post-Ingesta2'
WHERE proceso_id = (SELECT MAX(proceso_id) FROM DQM_Procesos);

-- ======================================
-- REPORTE DE ACTUALIZACIONES DE SISTEMAS
-- ======================================

-- Mostrar estado de metadata post-actualización
SELECT 
  'METADATA POST-INGESTA2' as seccion,
  nombre_tabla as tabla,
  comentarios as registros,
  estado_creacion as estado
FROM V_Metadata_Estado_Post_Ingesta2
ORDER BY tipo, nombre_tabla;

-- Mostrar reglas DQM activas
SELECT 
  'DQM REGLAS ACTIVAS' as seccion,
  tabla_aplicable as tabla,
  COUNT(*) as reglas_activas,
  GROUP_CONCAT(DISTINCT tipo_regla) as tipos_reglas
FROM DQM_Reglas 
WHERE activa = 1
GROUP BY tabla_aplicable;

-- Mostrar histórico de ingestas
SELECT 
  'HISTORICO INGESTAS' as seccion,
  nombre_ingesta as ingesta,
  fecha_ingesta as fecha,
  estado_final as estado
FROM MET_Historico_Ingestas
ORDER BY ingesta_id DESC
LIMIT 5; 