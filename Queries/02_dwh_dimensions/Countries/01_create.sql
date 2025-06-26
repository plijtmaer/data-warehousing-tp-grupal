-- Creación de tabla dimensional para países enriquecidos

CREATE TABLE DWH_Dim_Countries (
  country TEXT PRIMARY KEY,
  population TEXT,
  gdp TEXT,
  life_expectancy TEXT,
  latitude REAL,
  longitude REAL
);