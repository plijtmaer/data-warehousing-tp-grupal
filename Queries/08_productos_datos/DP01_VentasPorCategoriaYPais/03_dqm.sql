-- Registrar publicación del producto de datos en DQM_Procesos

INSERT INTO DQM_Procesos (
  nombre_proceso, tipo_proceso, tabla_origen, tabla_destino, estado, registros_procesados, observaciones
)
VALUES (
  'Publicación DP01_VentasPorCategoriaYPais',
  'producto_dato',
  'DWH_*',
  'DP01_VentasPorCategoriaYPais',
  'exitoso',
  (SELECT COUNT(*) FROM DP01_VentasPorCategoriaYPais),
  'Ventas por categoría y país generadas correctamente.'
);
