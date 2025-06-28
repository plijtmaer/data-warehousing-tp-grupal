-- Registrar publicación del producto de datos en DQM_Procesos

INSERT INTO DQM_Procesos (
  nombre_proceso, tipo_proceso, tabla_origen, tabla_destino, estado, registros_procesados, observaciones
)
VALUES (
  'Publicación DP02_PedidosPorEmpleado',
  'producto_dato',
  'DWH_*',
  'DP02_PedidosPorEmpleado',
  'exitoso',
  (SELECT COUNT(*) FROM DP02_PedidosPorEmpleado),
  'Pedidos por empleado publicados correctamente.'
);
