-- CAPA DE MEMORIA
-- Punto 6: Capa para preservar datos históricos y versionado

-- ========================================
-- 1. TABLA DE MEMORIA PARA CLIENTES
-- ========================================

CREATE TABLE IF NOT EXISTS MEM_Customers_History (
  version_id INTEGER PRIMARY KEY AUTOINCREMENT,
  customerID TEXT NOT NULL,
  companyName TEXT,
  contactName TEXT,
  contactTitle TEXT,
  address TEXT,
  city TEXT,
  region TEXT,
  postalCode TEXT,
  country TEXT,
  phone TEXT,
  fax TEXT,
  fecha_vigencia_desde DATE NOT NULL,
  fecha_vigencia_hasta DATE,
  tipo_operacion TEXT, -- 'INSERT', 'UPDATE', 'DELETE'
  proceso_id INTEGER,
  FOREIGN KEY (proceso_id) REFERENCES DQM_Procesos(proceso_id)
);

-- ========================================
-- 2. TABLA DE MEMORIA PARA PRODUCTOS
-- ========================================

CREATE TABLE IF NOT EXISTS MEM_Products_History (
  version_id INTEGER PRIMARY KEY AUTOINCREMENT,
  productID INTEGER NOT NULL,
  productName TEXT,
  supplierID INTEGER,
  categoryID INTEGER,
  quantityPerUnit TEXT,
  unitPrice REAL,
  unitsInStock INTEGER,
  unitsOnOrder INTEGER,
  reorderLevel INTEGER,
  discontinued INTEGER,
  fecha_vigencia_desde DATE NOT NULL,
  fecha_vigencia_hasta DATE,
  tipo_operacion TEXT,
  proceso_id INTEGER,
  FOREIGN KEY (proceso_id) REFERENCES DQM_Procesos(proceso_id)
);

-- ========================================
-- 3. TABLA DE MEMORIA PARA EMPLEADOS
-- ========================================

CREATE TABLE IF NOT EXISTS MEM_Employees_History (
  version_id INTEGER PRIMARY KEY AUTOINCREMENT,
  employeeID INTEGER NOT NULL,
  lastName TEXT,
  firstName TEXT,
  title TEXT,
  titleOfCourtesy TEXT,
  birthDate TEXT,
  hireDate TEXT,
  address TEXT,
  city TEXT,
  region TEXT,
  postalCode TEXT,
  country TEXT,
  homePhone TEXT,
  extension TEXT,
  notes TEXT,
  reportsTo INTEGER,
  fecha_vigencia_desde DATE NOT NULL,
  fecha_vigencia_hasta DATE,
  tipo_operacion TEXT,
  proceso_id INTEGER,
  FOREIGN KEY (proceso_id) REFERENCES DQM_Procesos(proceso_id)
);

-- ========================================
-- 4. FUNCIONES DE HISTORIZACIÓN
-- ========================================

-- Trigger para historizar cambios en clientes (sería ideal en un DBMS que soporte triggers)
-- En SQLite, se debe ejecutar manualmente antes de cada UPDATE

-- Ejemplo de historización manual para clientes:
/*
-- ANTES DE HACER UPDATE EN DWH_Dim_Customers:

INSERT INTO MEM_Customers_History 
SELECT 
  NULL as version_id,
  customerID, companyName, contactName, contactTitle, address, 
  city, region, postalCode, country, phone, fax,
  DATE('now') as fecha_vigencia_desde,
  NULL as fecha_vigencia_hasta,
  'UPDATE' as tipo_operacion,
  (SELECT MAX(proceso_id) FROM DQM_Procesos) as proceso_id
FROM DWH_Dim_Customers 
WHERE customerID = 'ALFKI'; -- ejemplo

-- DESPUÉS DEL UPDATE, actualizar fecha de vigencia:
UPDATE MEM_Customers_History 
SET fecha_vigencia_hasta = DATE('now')
WHERE customerID = 'ALFKI' 
  AND fecha_vigencia_hasta IS NULL
  AND version_id < (SELECT MAX(version_id) FROM MEM_Customers_History WHERE customerID = 'ALFKI');
*/

-- ========================================
-- 5. CONSULTAS DE LA CAPA DE MEMORIA
-- ========================================

-- Ver historial completo de un cliente
CREATE VIEW IF NOT EXISTS VW_Customer_History AS
SELECT 
  customerID,
  companyName,
  city,
  country,
  fecha_vigencia_desde,
  fecha_vigencia_hasta,
  tipo_operacion,
  CASE 
    WHEN fecha_vigencia_hasta IS NULL THEN 'VIGENTE'
    ELSE 'HISTÓRICO'
  END as estado
FROM MEM_Customers_History
ORDER BY customerID, fecha_vigencia_desde DESC;

-- Ver versión actual vs histórica de productos
CREATE VIEW IF NOT EXISTS VW_Product_Changes AS
SELECT 
  p.productID,
  p.productName,
  p.unitPrice as precio_actual,
  ph.unitPrice as precio_historico,
  ph.fecha_vigencia_desde,
  ROUND(
    ((p.unitPrice - ph.unitPrice) * 100.0 / ph.unitPrice), 2
  ) as variacion_porcentual
FROM DWH_Dim_Products p
JOIN MEM_Products_History ph ON p.productID = ph.productID
WHERE ph.fecha_vigencia_hasta IS NOT NULL
  AND p.unitPrice != ph.unitPrice; 