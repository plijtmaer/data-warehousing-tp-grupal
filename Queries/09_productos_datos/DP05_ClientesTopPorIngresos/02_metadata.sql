-- Carga en MET_Tablas y MET_Campos

-- Tabla
INSERT INTO MET_Tablas (
  nombre_tabla, descripcion, tipo, fecha_creacion, creado_por, comentarios
)
VALUES (
  'DP05_ClientesTopPorIngresos',
  'Clientes que generaron mayor monto total de ingresos por ventas',
  'Producto de Datos',
  DATE('now'),
  'Grupo 10',
  'Permite identificar clientes estratégicos según el volumen total de ingresos que generaron. Útil para segmentación, fidelización y análisis comercial.'
);

-- Campos
INSERT INTO MET_Campos VALUES
('DP05_ClientesTopPorIngresos', 'customerID', 'TEXT', 'ID del cliente', 'No', 'Sí'),
('DP05_ClientesTopPorIngresos', 'companyName', 'TEXT', 'Nombre de la empresa del cliente', 'No', 'Sí'),
('DP05_ClientesTopPorIngresos', 'country', 'TEXT', 'País del cliente', 'No', 'Sí'),
('DP05_ClientesTopPorIngresos', 'total_ingresos', 'REAL', 'Monto total de ingresos por ventas', 'Sí', 'No');
