-- Creación de tabla dimensional para territorios

CREATE TABLE IF NOT EXISTS DWH_Dim_Territories (
  territoryID TEXT PRIMARY KEY,
  territoryDescription TEXT,
  regionID INTEGER,
  FOREIGN KEY (regionID) REFERENCES DWH_Dim_Regions(regionID)
);
