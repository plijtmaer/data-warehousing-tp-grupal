-- Registrar publicación del producto de datos en DQM_Procesos

INSERT INTO DQM_Procesos (
  nombre_proceso, tipo_proceso, tabla_origen, tabla_destino, estado, registros_procesados, observaciones
)
VALUES (
  'Publicación DP05_ClientesTopPorIngresos',
  'producto_dato',
  'DWH_*',
  'DP05_ClientesTopPorIngresos',
  'exitoso',
  (SELECT COUNT(*) FROM DP05_ClientesTopPorIngresos),
  'Clientes top por ingresos generados correctamente.'
);
