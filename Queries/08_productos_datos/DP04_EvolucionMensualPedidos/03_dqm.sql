-- Registrar publicación del producto de datos en DQM_Procesos

INSERT INTO DQM_Procesos (
  nombre_proceso, tipo_proceso, tabla_origen, tabla_destino, estado, registros_procesados, observaciones
)
VALUES (
  'Publicación DP04_EvolucionMensualPedidos',
  'producto_dato',
  'DWH_*',
  'DP04_EvolucionMensualPedidos',
  'exitoso',
  (SELECT COUNT(*) FROM DP04_EvolucionMensualPedidos),
  'Evolución mensual de pedidos cargada correctamente.'
);
