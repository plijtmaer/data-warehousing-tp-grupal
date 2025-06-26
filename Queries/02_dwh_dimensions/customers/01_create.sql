-- Creación de Tabla Dimensional Customers
-- Se incluyen campos importantes para analisis de ventas por cliente y geografia
-- Se excluyen campos de detalle como address, fax que no se usan en reportes

CREATE TABLE IF NOT EXISTS DWH_Dim_Customers (
  customerID TEXT PRIMARY KEY,
  companyName TEXT,
  contactName TEXT,
  contactTitle TEXT,
  address TEXT,
  city TEXT,
  region TEXT,
  postalCode TEXT,
  country TEXT,
  phone TEXT,
  fax TEXT
);

