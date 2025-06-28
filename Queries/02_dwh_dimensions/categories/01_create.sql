-- Creación de tabla dimensional para categories

CREATE TABLE IF NOT EXISTS DWH_Dim_Categories (
  categoryID INTEGER PRIMARY KEY,
  categoryName TEXT,
  description TEXT
);

