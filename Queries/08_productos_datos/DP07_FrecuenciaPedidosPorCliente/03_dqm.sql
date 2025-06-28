-- Registrar publicación del producto de datos en DQM_Procesos

INSERT INTO DQM_Procesos (
  nombre_proceso, tipo_proceso, tabla_origen, tabla_destino, estado, registros_procesados, observaciones
)
VALUES (
  'Publicación DP07_FrecuenciaPedidosPorCliente',
  'producto_dato',
  'DWH_*',
  'DP07_FrecuenciaPedidosPorCliente',
  'exitoso',
  (SELECT COUNT(*) FROM DP07_FrecuenciaPedidosPorCliente),
  'Frecuencia de pedidos por cliente cargada correctamente.'
);
