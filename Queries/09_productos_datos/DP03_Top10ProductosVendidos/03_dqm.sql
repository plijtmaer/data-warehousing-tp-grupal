-- Registrar publicación del producto de datos en DQM_Procesos

INSERT INTO DQM_Procesos (
  nombre_proceso, tipo_proceso, tabla_origen, tabla_destino, estado, registros_procesados, observaciones
)
VALUES (
  'Publicación DP03_Top10ProductosVendidos',
  'producto_dato',
  'DWH_*',
  'DP03_Top10ProductosVendidos',
  'exitoso',
  (SELECT COUNT(*) FROM DP03_Top10ProductosVendidos),
  'Top 10 productos más vendidos publicados correctamente.'
);
