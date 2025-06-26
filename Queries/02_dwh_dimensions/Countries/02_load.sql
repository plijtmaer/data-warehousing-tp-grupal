-- Limpieza previa de registros duplicados
DELETE FROM DWH_Dim_Countries;

-- Inserción desde TMP_WorldData2023
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
FROM TMP_WorldData2023;
