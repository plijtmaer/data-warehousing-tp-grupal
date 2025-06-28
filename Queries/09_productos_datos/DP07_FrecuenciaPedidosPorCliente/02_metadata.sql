-- Carga en MET_Tablas y MET_Campos

-- Tabla
INSERT INTO MET_Tablas (
  nombre_tabla, descripcion, tipo, fecha_creacion, creado_por, comentarios
)
VALUES (
  'DP07_FrecuenciaPedidosPorCliente',
  'Cantidad total de pedidos realizados por cada cliente',
  'Producto de Datos',
  DATE('now'),
  'Grupo 10',
  'Permite analizar la frecuencia de compra de los clientes. Útil para segmentación, detección de clientes recurrentes y planificación comercial.'
);

-- Campos
INSERT INTO MET_Campos VALUES
('DP07_FrecuenciaPedidosPorCliente', 'customerID', 'TEXT', 'ID del cliente', 'No', 'Sí'),
('DP07_FrecuenciaPedidosPorCliente', 'companyName', 'TEXT', 'Nombre de la empresa del cliente', 'No', 'Sí'),
('DP07_FrecuenciaPedidosPorCliente', 'country', 'TEXT', 'País del cliente', 'No', 'Sí'),
('DP07_FrecuenciaPedidosPorCliente', 'cantidad_pedidos', 'INTEGER', 'Cantidad total de pedidos realizados', 'Sí', 'No');
