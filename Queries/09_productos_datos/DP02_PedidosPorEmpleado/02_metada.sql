-- Carga en MET_Tablas y MET_Campos

-- Tabla
INSERT INTO MET_Tablas (
  nombre_tabla, descripcion, tipo, fecha_creacion, creado_por, comentarios
)
VALUES (
  'DP02_PedidosPorEmpleado',
  'Cantidad total de pedidos gestionados por cada empleado',
  'Producto de Datos',
  DATE('now'),
  'Grupo 10',
  'Permite analizar la distribución operativa de pedidos entre empleados. Útil para reportes de carga de trabajo y rendimiento por agente.'
);

-- Campos
INSERT INTO MET_Campos VALUES
('DP02_PedidosPorEmpleado', 'employeeID', 'INTEGER', 'Identificador del empleado', 'No', 'Sí'),
('DP02_PedidosPorEmpleado', 'fullName', 'TEXT', 'Nombre completo del empleado (generado como firstName + lastName)', 'Derivado', 'Sí'),
('DP02_PedidosPorEmpleado', 'cantidad_pedidos', 'INTEGER', 'Cantidad total de pedidos gestionados', 'Sí', 'No');
