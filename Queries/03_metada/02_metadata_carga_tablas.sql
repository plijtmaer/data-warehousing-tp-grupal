
-- TABLAS DE STAGING (TMP_)

INSERT INTO MET_Tablas VALUES ('TMP_Orders', 'Pedidos extraídos del sistema transaccional', 'staging', '2025-06-25', 'Grupo 10', 'Primera ingesta de pedidos');
INSERT INTO MET_Tablas VALUES ('TMP_OrderDetails', 'Detalle de productos por pedido', 'staging', '2025-06-25', 'Grupo 10', 'Incluye cantidad, precio, descuento');
INSERT INTO MET_Tablas VALUES ('TMP_Customers', 'Clientes registrados', 'staging', '2025-06-25', 'Grupo 10', 'Clientes originales de Ingesta 1');
INSERT INTO MET_Tablas VALUES ('TMP_Employees', 'Empleados de la empresa', 'staging', '2025-06-25', 'Grupo 10', 'Contiene jerarquía reportsTo');
INSERT INTO MET_Tablas VALUES ('TMP_Products', 'Productos disponibles', 'staging', '2025-06-25', 'Grupo 10', 'Unido luego con categorías y proveedores');
INSERT INTO MET_Tablas VALUES ('TMP_Shippers', 'Transportistas registrados', 'staging', '2025-06-25', 'Grupo 10', '');
INSERT INTO MET_Tablas VALUES ('TMP_Suppliers', 'Proveedores de productos', 'staging', '2025-06-25', 'Grupo 10', '');
INSERT INTO MET_Tablas VALUES ('TMP_Categories', 'Categorías de productos', 'staging', '2025-06-25', 'Grupo 10', '');
INSERT INTO MET_Tablas VALUES ('TMP_Regions', 'Regiones geográficas', 'staging', '2025-06-25', 'Grupo 10', '');
INSERT INTO MET_Tablas VALUES ('TMP_Territories', 'Territorios asociados a regiones', 'staging', '2025-06-25', 'Grupo 10', '');
INSERT INTO MET_Tablas VALUES ('TMP_EmployeeTerritories', 'Relaciones entre empleados y territorios', 'staging', '2025-06-25', 'Grupo 10', '');
INSERT INTO MET_Tablas VALUES ('TMP_WorldData2023', 'Datos externos de países del mundo', 'staging', '2025-06-25', 'Grupo 10', 'Archivo externo complementario');
INSERT INTO MET_Tablas VALUES ('TMP_Employees_Fix', 'Versión corregida de empleados', 'staging', '2025-06-25', 'Grupo 10', 'Tabla auxiliar para jerarquía válida');


-- DIMENSIONES (DWH_Dim_)

INSERT INTO MET_Tablas VALUES ('DWH_Dim_Customers', 'Clientes con país, ciudad y contacto', 'dimension', '2025-06-25', 'Grupo 10', '');
INSERT INTO MET_Tablas VALUES ('DWH_Dim_Employees', 'Empleados con jerarquía (reportTo)', 'dimension', '2025-06-25', 'Grupo 10', 'Corregido con tabla FIX');
INSERT INTO MET_Tablas VALUES ('DWH_Dim_Products', 'Productos con categoría y proveedor', 'dimension', '2025-06-25', 'Grupo 10', '');
INSERT INTO MET_Tablas VALUES ('DWH_Dim_Shippers', 'Transportistas para órdenes', 'dimension', '2025-06-25', 'Grupo 10', '');
INSERT INTO MET_Tablas VALUES ('DWH_Dim_Suppliers', 'Proveedores con contacto y dirección', 'dimension', '2025-06-25', 'Grupo 10', '');
INSERT INTO MET_Tablas VALUES ('DWH_Dim_Categories', 'Categorías de productos', 'dimension', '2025-06-25', 'Grupo 10', '');
INSERT INTO MET_Tablas VALUES ('DWH_Dim_Regions', 'Regiones normalizadas', 'dimension', '2025-06-25', 'Grupo 10', '');
INSERT INTO MET_Tablas VALUES ('DWH_Dim_Territories', 'Territorios asociados a regiones', 'dimension', '2025-06-25', 'Grupo 10', '');
INSERT INTO MET_Tablas VALUES ('DWH_Dim_Countries', 'Datos enriquecidos por país desde archivo externo', 'dimension', '2025-06-25', 'Grupo 10', 'Contiene GDP, expectativa de vida, coordenadas');
INSERT INTO MET_Tablas VALUES ('DWH_Dim_Time', 'Dimensión de tiempo con año, mes, día y semana', 'dimension', '2025-06-25', 'Grupo 10', 'Clave para análisis temporales');


-- HECHOS (DWH_Fact_)

INSERT INTO MET_Tablas VALUES ('DWH_Fact_Orders', 'Órdenes realizadas con empleado, cliente y fecha', 'hecho', '2025-06-25', 'Grupo 10', '');
INSERT INTO MET_Tablas VALUES ('DWH_Fact_OrderDetails', 'Detalle de cada producto por pedido', 'hecho', '2025-06-25', 'Grupo 10', 'Incluye cálculo derivado');


-- METADATA

INSERT INTO MET_Tablas VALUES ('MET_Tablas', 'Listado de todas las tablas del DWH', 'metadata', '2025-06-25', 'Grupo 10', 'Incluye tipo, fecha, autor y comentarios');
INSERT INTO MET_Tablas VALUES ('MET_Campos', 'Detalle de los campos de cada tabla', 'metadata', '2025-06-25', 'Grupo 10', 'Incluye tipo de dato y descripción');
