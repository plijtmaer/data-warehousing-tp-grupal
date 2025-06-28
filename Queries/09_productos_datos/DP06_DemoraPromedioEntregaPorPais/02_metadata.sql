-- Carga en MET_Tablas y MET_Campos

-- Tabla
INSERT INTO MET_Tablas (
  nombre_tabla, descripcion, tipo, fecha_creacion, creado_por, comentarios
)
VALUES (
  'DP06_DemoraPromedioEntregaPorPais',
  'Cantidad promedio de días entre la fecha del pedido y la fecha de envío por país del cliente',
  'Producto de Datos',
  DATE('now'),
  'Grupo 10',
  'Permite evaluar la eficiencia logística según el tiempo promedio que demora el envío de pedidos en cada país. Útil para control operativo y mejora de servicio.'
);

-- Campos
INSERT INTO MET_Campos VALUES
('DP06_DemoraPromedioEntregaPorPais', 'country', 'TEXT', 'País del cliente', 'No', 'Sí'),
('DP06_DemoraPromedioEntregaPorPais', 'demora_promedio_dias', 'REAL', 'Promedio de días entre pedido y envío', 'Sí', 'No');
