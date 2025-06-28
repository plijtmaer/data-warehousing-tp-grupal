-- Carga en MET_Tablas y MET_Campos

-- Tabla
INSERT INTO MET_Tablas (
  nombre_tabla, descripcion, tipo, fecha_creacion, creado_por, comentarios
)
VALUES (
  'DP04_EvolucionMensualPedidos',
  'Cantidad total de pedidos realizados por mes y año',
  'Producto de Datos',
  DATE('now'),
  'Grupo 10',
  'Permite analizar la evolución mensual de los pedidos a lo largo del tiempo. Útil para detectar estacionalidades, tendencias y proyectar demanda.'
);

-- Campos
INSERT INTO MET_Campos VALUES
('DP04_EvolucionMensualPedidos', 'year', 'INTEGER', 'Año del pedido', 'No', 'Sí'),
('DP04_EvolucionMensualPedidos', 'month', 'INTEGER', 'Mes numérico del pedido', 'No', 'Sí'),
('DP04_EvolucionMensualPedidos', 'month_name', 'TEXT', 'Nombre del mes del pedido', 'No', 'Sí'),
('DP04_EvolucionMensualPedidos', 'cantidad_pedidos', 'INTEGER', 'Cantidad total de pedidos realizados en ese mes', 'Sí', 'No');
