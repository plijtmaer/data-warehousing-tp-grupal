-- Creación de tabla dimensional para regiones
CREATE TABLE IF NOT EXISTS DWH_Dim_Regions (
  regionID INTEGER PRIMARY KEY,
  regionDescription TEXT
);
