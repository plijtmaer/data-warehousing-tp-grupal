-- Creación de Tabla Dimensional Customers

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

