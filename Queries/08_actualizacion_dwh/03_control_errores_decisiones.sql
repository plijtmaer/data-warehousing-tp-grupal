-- CONTROL DE ERRORES Y DECISIONES - Punto 9d
-- Sistema para decidir si cancelar, procesar parcial o totalmente

-- Crear tabla para decisiones de actualización
CREATE TABLE IF NOT EXISTS DQM_Decisiones_Update (
  decision_id INTEGER PRIMARY KEY AUTOINCREMENT,
  proceso_id INTEGER,
  tipo_error TEXT,
  gravedad TEXT CHECK(gravedad IN ('critico', 'alto', 'medio', 'bajo')),
  decision TEXT CHECK(decision IN ('cancelar_todo', 'procesar_parcial', 'procesar_todo', 'corregir_y_continuar')),
  justificacion TEXT,
  fecha_decision TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (proceso_id) REFERENCES DQM_Procesos(proceso_id)
);

-- Función de evaluación de errores para Ingesta2
-- Registrar evaluación global de la actualización
INSERT INTO DQM_Procesos (
  nombre_proceso, tipo_proceso, tabla_origen,
  estado, observaciones
) VALUES (
  'Evaluacion Global Ingesta2', 'control', 'ALL_ING2',
  'en_proceso', 'Evaluando si proceder con actualización'
);

-- 1. ANALIZAR ERRORES CRITICOS
-- Verificar si hay errores que impidan continuar
INSERT INTO DQM_Decisiones_Update (
  proceso_id, tipo_error, gravedad, decision, justificacion
)
SELECT 
  (SELECT MAX(proceso_id) FROM DQM_Procesos),
  'integridad_referencial',
  CASE 
    WHEN (SELECT COUNT(*) FROM DQM_Indicadores 
          WHERE resultado = 'rechazado' AND tipo_indicador = 'integridad') > 0 
    THEN 'critico'
    ELSE 'bajo'
  END,
  CASE 
    WHEN (SELECT COUNT(*) FROM DQM_Indicadores 
          WHERE resultado = 'rechazado' AND tipo_indicador = 'integridad') > 0 
    THEN 'cancelar_todo'
    ELSE 'procesar_todo'
  END,
  CASE 
    WHEN (SELECT COUNT(*) FROM DQM_Indicadores 
          WHERE resultado = 'rechazado' AND tipo_indicador = 'integridad') > 0 
    THEN 'Errores de integridad referencial detectados - cancelar para evitar corrupción'
    ELSE 'Integridad referencial válida - proceder con actualización completa'
  END;

-- 2. ANALIZAR ERRORES DE UNICIDAD
INSERT INTO DQM_Decisiones_Update (
  proceso_id, tipo_error, gravedad, decision, justificacion
)
SELECT 
  (SELECT MAX(proceso_id) FROM DQM_Procesos),
  'unicidad_orders',
  CASE 
    WHEN (SELECT valor_indicador FROM DQM_Indicadores 
          WHERE tipo_indicador = 'unicidad' AND tabla_nombre = 'TMP_Orders_ING2') < 90.0 
    THEN 'alto'
    ELSE 'bajo'
  END,
  CASE 
    WHEN (SELECT valor_indicador FROM DQM_Indicadores 
          WHERE tipo_indicador = 'unicidad' AND tabla_nombre = 'TMP_Orders_ING2') < 90.0 
    THEN 'procesar_parcial'
    ELSE 'procesar_todo'
  END,
  CASE 
    WHEN (SELECT valor_indicador FROM DQM_Indicadores 
          WHERE tipo_indicador = 'unicidad' AND tabla_nombre = 'TMP_Orders_ING2') < 90.0 
    THEN 'Muchas orders duplicadas - procesar solo las válidas'
    ELSE 'Nivel aceptable de orders nuevas - procesar todo'
  END;

-- 3. TOMAR DECISION FINAL
-- Regla: Si hay errores críticos -> cancelar
-- Si hay errores altos -> procesar parcial
-- Si no hay errores críticos/altos -> procesar todo

UPDATE DQM_Procesos 
SET estado = CASE 
  WHEN (SELECT COUNT(*) FROM DQM_Decisiones_Update 
        WHERE proceso_id = (SELECT MAX(proceso_id) FROM DQM_Procesos)
        AND gravedad = 'critico' AND decision = 'cancelar_todo') > 0 
  THEN 'cancelado'
  WHEN (SELECT COUNT(*) FROM DQM_Decisiones_Update 
        WHERE proceso_id = (SELECT MAX(proceso_id) FROM DQM_Procesos)
        AND gravedad = 'alto' AND decision = 'procesar_parcial') > 0 
  THEN 'parcial'
  ELSE 'aprobado'
END,
observaciones = CASE 
  WHEN (SELECT COUNT(*) FROM DQM_Decisiones_Update 
        WHERE proceso_id = (SELECT MAX(proceso_id) FROM DQM_Procesos)
        AND gravedad = 'critico' AND decision = 'cancelar_todo') > 0 
  THEN 'CANCELADO: Errores críticos detectados'
  WHEN (SELECT COUNT(*) FROM DQM_Decisiones_Update 
        WHERE proceso_id = (SELECT MAX(proceso_id) FROM DQM_Procesos)
        AND gravedad = 'alto' AND decision = 'procesar_parcial') > 0 
  THEN 'PARCIAL: Procesar solo registros válidos'
  ELSE 'APROBADO: Procesar actualización completa'
END
WHERE proceso_id = (SELECT MAX(proceso_id) FROM DQM_Procesos);

-- 4. CREAR VIEW PARA MONITOREO DE DECISIONES
CREATE VIEW IF NOT EXISTS V_Estado_Actualizacion AS
SELECT 
  p.nombre_proceso,
  p.estado,
  p.observaciones,
  d.tipo_error,
  d.gravedad,
  d.decision,
  d.justificacion,
  d.fecha_decision
FROM DQM_Procesos p
LEFT JOIN DQM_Decisiones_Update d ON p.proceso_id = d.proceso_id
WHERE p.nombre_proceso = 'Evaluacion Global Ingesta2';

-- 5. MOSTRAR RESULTADO DE LA EVALUACION
SELECT 
  'DECISION FINAL' as tipo,
  estado as resultado,
  observaciones as detalle
FROM DQM_Procesos 
WHERE nombre_proceso = 'Evaluacion Global Ingesta2'
UNION ALL
SELECT 
  'DETALLE: ' || tipo_error as tipo,
  gravedad || ' -> ' || decision as resultado,
  justificacion as detalle
FROM DQM_Decisiones_Update 
WHERE proceso_id = (SELECT proceso_id FROM DQM_Procesos WHERE nombre_proceso = 'Evaluacion Global Ingesta2')
ORDER BY tipo; 