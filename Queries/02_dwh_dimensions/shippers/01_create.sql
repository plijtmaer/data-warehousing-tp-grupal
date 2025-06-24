-- Creación de tabla dimensional para transportistas

CREATE TABLE IF NOT EXISTS DWH_Dim_Shippers (
  shipperID INTEGER PRIMARY KEY,
  companyName TEXT,
  phone TEXT
);
