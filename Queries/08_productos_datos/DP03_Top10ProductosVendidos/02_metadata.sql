-- Carga en MET_Tablas y MET_Campos

-- Tabla
INSERT INTO MET_Tablas (
  nombre_tabla, descripcion, tipo, fecha_creacion, creado_por, comentarios
)
VALUES (
  'DP03_Top10ProductosVendidos',
  'Top 10 productos con mayor cantidad de unidades vendidas',
  'Producto de Datos',
  DATE('now'),
  'Grupo 10',
  'Permite identificar los productos más demandados en términos de volumen vendido. Útil para marketing, promociones y planificación de inventario.'
);

-- Campos
INSERT INTO MET_Campos VALUES
('DP03_Top10ProductosVendidos', 'productID', 'INTEGER', 'Identificador del producto', 'No', 'Sí'),
('DP03_Top10ProductosVendidos', 'productName', 'TEXT', 'Nombre del producto', 'No', 'Sí'),
('DP03_Top10ProductosVendidos', 'cantidad_vendida', 'INTEGER', 'Cantidad total de unidades vendidas', 'Sí', 'No');
