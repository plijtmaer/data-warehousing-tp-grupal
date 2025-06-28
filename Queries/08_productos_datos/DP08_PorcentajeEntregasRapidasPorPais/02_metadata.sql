-- Carga en MET_Tablas y MET_Campos

-- Tabla
INSERT INTO MET_Tablas (
  nombre_tabla, descripcion, tipo, fecha_creacion, creado_por, comentarios
)
VALUES (
  'DP08_PorcentajeEntregasRapidasPorPais',
  'Porcentaje de pedidos entregados en 5 días o menos por país del cliente',
  'Producto de Datos',
  DATE('now'),
  'Grupo 10',
  'Permite analizar el desempeño logístico por país según la proporción de pedidos entregados en 5 días o menos desde su emisión. Útil para monitoreo de eficiencia operativa y cumplimiento de SLA.'
);

-- Campos
INSERT INTO MET_Campos VALUES
('DP08_PorcentajeEntregasRapidasPorPais', 'country', 'TEXT', 'País del cliente', 'No', 'Sí'),
('DP08_PorcentajeEntregasRapidasPorPais', 'porcentaje_entregas_rapidas', 'REAL', 'Porcentaje de entregas realizadas en 5 días o menos', 'Sí', 'No');
