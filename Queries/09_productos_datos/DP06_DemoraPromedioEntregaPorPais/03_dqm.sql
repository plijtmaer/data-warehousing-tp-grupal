-- Registrar publicación del producto de datos en DQM_Procesos

INSERT INTO DQM_Procesos (
  nombre_proceso, tipo_proceso, tabla_origen, tabla_destino, estado, registros_procesados, observaciones
)
VALUES (
  'Publicación DP06_DemoraPromedioEntregaPorPais',
  'producto_dato',
  'DWH_*',
  'DP06_DemoraPromedioEntregaPorPais',
  'exitoso',
  (SELECT COUNT(*) FROM DP06_DemoraPromedioEntregaPorPais),
  'Demora promedio por país publicada correctamente.'
);
