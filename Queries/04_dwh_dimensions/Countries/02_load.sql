-- Limpieza previa de registros duplicados
DELETE FROM DWH_Dim_Countries;

-- Inserción desde STG_WorldData2023 (con correcciones de países y encoding)
INSERT INTO DWH_Dim_Countries (
  country,
  population,
  gdp,
  life_expectancy,
  latitude,
  longitude
)
SELECT
  country,
  population,
  gdp,
  life_expectancy,
  latitude,
  longitude
FROM STG_WorldData2023;
