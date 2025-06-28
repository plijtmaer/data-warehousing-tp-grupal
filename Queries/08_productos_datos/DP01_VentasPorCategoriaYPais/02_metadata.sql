-- Carga en MET_Tablas y MET_Campos

-- Tabla
INSERT INTO MET_Tablas (
  nombre_tabla, descripcion, tipo, fecha_creacion, creado_por, comentarios
)
VALUES (
  'DP01_VentasPorCategoriaYPais',
  'Total de ventas y cantidad de productos vendidos por categoría de producto y país del cliente',
  'Producto de Datos',
  DATE('now'),
  'Grupo 10',
  'Permite analizar las ventas totales y cantidades vendidas por categoría de producto y país del cliente, útil para decisiones comerciales regionales.'
);

-- Campos
INSERT INTO MET_Campos VALUES
('DP01_VentasPorCategoriaYPais', 'country', 'TEXT', 'País del cliente', 'No', 'Sí'),
('DP01_VentasPorCategoriaYPais', 'categoryName', 'TEXT', 'Nombre de la categoría del producto', 'No', 'Sí'),
('DP01_VentasPorCategoriaYPais', 'total_ventas', 'REAL', 'Monto total de ventas por país y categoría', 'Sí', 'No'),
('DP01_VentasPorCategoriaYPais', 'cantidad_productos', 'INTEGER', 'Cantidad total de productos vendidos', 'Sí', 'No');
