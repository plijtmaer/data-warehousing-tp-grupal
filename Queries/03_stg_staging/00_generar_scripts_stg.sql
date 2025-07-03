-- GENERADOR DE SCRIPTS STG PARA TABLAS SIMPLES
-- Este script genera los archivos para todas las tablas que solo necesitan copia directa

-- TABLAS QUE NECESITAN SOLO COPIA DIRECTA:
-- STG_Products, STG_Orders, STG_OrderDetails, STG_Employees, STG_Categories, 
-- STG_Suppliers, STG_Shippers, STG_Regions, STG_Territories, STG_EmployeeTerritories

-- Configuración de tablas a procesar
CREATE TEMP TABLE IF NOT EXISTS stg_config (
    tabla_tmp TEXT,
    tabla_stg TEXT,
    campos_pk TEXT,
    campos_obligatorios TEXT,
    descripcion TEXT
);

INSERT INTO stg_config VALUES
('TMP_Products', 'STG_Products', 'productID', 'productID,productName,unitPrice', 'Productos del catálogo'),
('TMP_Orders', 'STG_Orders', 'orderID', 'orderID,customerID,orderDate', 'Órdenes de venta'),
('TMP_OrderDetails', 'STG_OrderDetails', 'orderID,productID', 'orderID,productID,quantity,unitPrice', 'Detalles de órdenes'),
('TMP_Employees', 'STG_Employees', 'employeeID', 'employeeID,firstName,lastName', 'Empleados (ya corregido)'),
('TMP_Categories', 'STG_Categories', 'categoryID', 'categoryID,categoryName', 'Categorías de productos'),
('TMP_Suppliers', 'STG_Suppliers', 'supplierID', 'supplierID,companyName', 'Proveedores'),
('TMP_Shippers', 'STG_Shippers', 'shipperID', 'shipperID,companyName', 'Transportistas'),
('TMP_Regions', 'STG_Regions', 'regionID', 'regionID,regionDescription', 'Regiones geográficas'),
('TMP_Territories', 'STG_Territories', 'territoryID', 'territoryID,territoryDescription,regionID', 'Territorios'),
('TMP_EmployeeTerritories', 'STG_EmployeeTerritories', 'employeeID,territoryID', 'employeeID,territoryID', 'Relación empleado-territorio');

-- =========================================================
-- INSTRUCCIONES PARA CREAR LOS SCRIPTS MANUALMENTE
-- =========================================================

SELECT 'INSTRUCCIONES: Crear los siguientes archivos usando los templates:' as instruccion;

-- Template CREATE para cada tabla
SELECT 
    'Archivo: Queries/03_stg_staging/' || REPLACE(tabla_stg, 'STG_', '') || '/01_create.sql' as archivo,
    '-- CREAR ' || tabla_stg || CHAR(10) ||
    'CREATE TABLE IF NOT EXISTS ' || tabla_stg || ' (' || CHAR(10) ||
    '    -- [COPIAR ESTRUCTURA DE ' || tabla_tmp || ' + campos audit]' || CHAR(10) ||
    '    stg_created_date DATE DEFAULT CURRENT_DATE,' || CHAR(10) ||
    '    stg_data_quality_score REAL DEFAULT 1.0' || CHAR(10) ||
    ');' as contenido
FROM stg_config;

-- Template LOAD para cada tabla  
SELECT 
    'Archivo: Queries/03_stg_staging/' || REPLACE(tabla_stg, 'STG_', '') || '/02_load.sql' as archivo,
    '-- CARGAR ' || tabla_stg || CHAR(10) ||
    'DELETE FROM ' || tabla_stg || ';' || CHAR(10) ||
    'INSERT INTO ' || tabla_stg || ' SELECT *, CURRENT_DATE, 1.0 FROM ' || tabla_tmp || ';' || CHAR(10) ||
    'SELECT COUNT(*) as registros_cargados FROM ' || tabla_stg || ';' as contenido
FROM stg_config;

-- =========================================================
-- ORDEN DE EJECUCIÓN RECOMENDADO
-- =========================================================

SELECT 'ORDEN DE EJECUCIÓN:' as seccion;

SELECT 
    ROW_NUMBER() OVER (ORDER BY tabla_stg) as orden,
    'Ejecutar: Queries/03_stg_staging/' || REPLACE(tabla_stg, 'STG_', '') || '/01_create.sql' as paso
FROM stg_config
UNION ALL
SELECT 100, '-- Luego ejecutar todos los 02_load.sql --'
UNION ALL
SELECT 
    100 + ROW_NUMBER() OVER (ORDER BY tabla_stg) as orden,
    'Ejecutar: Queries/03_stg_staging/' || REPLACE(tabla_stg, 'STG_', '') || '/02_load.sql' as paso
FROM stg_config
UNION ALL
SELECT 200, '-- Finalmente todos los 03_validate.sql --'
UNION ALL
SELECT 
    200 + ROW_NUMBER() OVER (ORDER BY tabla_stg) as orden,
    'Ejecutar: Queries/03_stg_staging/' || REPLACE(tabla_stg, 'STG_', '') || '/03_validate.sql' as paso
FROM stg_config
ORDER BY orden;

-- =========================================================
-- ESTADÍSTICAS PREVIAS PARA VALIDACIÓN
-- =========================================================

SELECT 'CONTADORES ORIGINALES TMP_ para validación:' as estadisticas;

SELECT 'TMP_Products' as tabla, COUNT(*) as registros FROM TMP_Products
UNION ALL SELECT 'TMP_Orders', COUNT(*) FROM TMP_Orders
UNION ALL SELECT 'TMP_OrderDetails', COUNT(*) FROM TMP_OrderDetails  
UNION ALL SELECT 'TMP_Employees', COUNT(*) FROM TMP_Employees
UNION ALL SELECT 'TMP_Categories', COUNT(*) FROM TMP_Categories
UNION ALL SELECT 'TMP_Suppliers', COUNT(*) FROM TMP_Suppliers
UNION ALL SELECT 'TMP_Shippers', COUNT(*) FROM TMP_Shippers
UNION ALL SELECT 'TMP_Regions', COUNT(*) FROM TMP_Regions
UNION ALL SELECT 'TMP_Territories', COUNT(*) FROM TMP_Territories
UNION ALL SELECT 'TMP_EmployeeTerritories', COUNT(*) FROM TMP_EmployeeTerritories;

-- Limpiar tabla temporal
DROP TABLE stg_config; 